#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_URL="${KAMI_UPSTREAM_URL:-https://github.com/tw93/Kami.git}"
REF="${1:-${KAMI_REF:-main}}"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "Fetching Kami from $UPSTREAM_URL"
mkdir -p "$TMP_DIR/Kami"
git -C "$TMP_DIR/Kami" init --quiet
git -C "$TMP_DIR/Kami" remote add origin "$UPSTREAM_URL"
if git -C "$TMP_DIR/Kami" fetch --quiet --depth 1 origin "$REF"; then
  git -C "$TMP_DIR/Kami" checkout --quiet FETCH_HEAD
else
  echo "Could not fetch ref '$REF' directly; trying main." >&2
  git -C "$TMP_DIR/Kami" fetch --quiet --depth 1 origin main
  git -C "$TMP_DIR/Kami" checkout --quiet FETCH_HEAD
fi

UPSTREAM_PLUGIN="$TMP_DIR/Kami/plugins/kami"
if [[ ! -d "$UPSTREAM_PLUGIN" ]]; then
  echo "Expected upstream plugin folder not found: plugins/kami" >&2
  exit 1
fi

UPSTREAM_VERSION="$(python3 - "$UPSTREAM_PLUGIN/.codex-plugin/plugin.json" <<'PY'
import json
import sys
from pathlib import Path

manifest = json.loads(Path(sys.argv[1]).read_text())
print(manifest.get("version", "0.0.0"))
PY
)"
COMMIT="$(git -C "$TMP_DIR/Kami" rev-parse HEAD)"
SHORT_COMMIT="${COMMIT:0:12}"
SYNC_DATE="$(date +%F)"

PREVIOUS_COMMIT=""
PREVIOUS_UPSTREAM_VERSION=""
PREVIOUS_PACKAGE_VERSION=""
if [[ -f "$ROOT_DIR/plugins/kami/SOURCE.md" ]]; then
  PREVIOUS_COMMIT="$(sed -n 's/^- Mirrored commit: `\\(.*\\)`/\\1/p' "$ROOT_DIR/plugins/kami/SOURCE.md" | head -1)"
  PREVIOUS_UPSTREAM_VERSION="$(sed -n 's/^- Upstream version: `\\(.*\\)`/\\1/p' "$ROOT_DIR/plugins/kami/SOURCE.md" | head -1)"
fi
if [[ -f "$ROOT_DIR/plugins/kami/.codex-plugin/plugin.json" ]]; then
  PREVIOUS_PACKAGE_VERSION="$(python3 - "$ROOT_DIR/plugins/kami/.codex-plugin/plugin.json" <<'PY'
import json
import sys
from pathlib import Path

manifest = json.loads(Path(sys.argv[1]).read_text())
print(manifest.get("version", ""))
PY
)"
fi

if [[ -n "${KAMI_PACKAGE_VERSION:-}" ]]; then
  PACKAGE_VERSION="$KAMI_PACKAGE_VERSION"
elif [[ "$COMMIT" == "$PREVIOUS_COMMIT" && -n "$PREVIOUS_PACKAGE_VERSION" ]]; then
  PACKAGE_VERSION="$PREVIOUS_PACKAGE_VERSION"
elif [[ -z "$PREVIOUS_UPSTREAM_VERSION" || "$UPSTREAM_VERSION" != "$PREVIOUS_UPSTREAM_VERSION" ]]; then
  PACKAGE_VERSION="$UPSTREAM_VERSION"
else
  PACKAGE_VERSION="${UPSTREAM_VERSION}+eclair.${SHORT_COMMIT}"
fi

echo "Syncing Kami upstream $UPSTREAM_VERSION as package $PACKAGE_VERSION at $COMMIT"
rm -rf "$ROOT_DIR/plugins/kami"
mkdir -p "$ROOT_DIR/plugins"
cp -R "$UPSTREAM_PLUGIN" "$ROOT_DIR/plugins/kami"
mkdir -p "$ROOT_DIR/plugins/kami/.claude-plugin"

python3 - "$ROOT_DIR" "$UPSTREAM_VERSION" "$PACKAGE_VERSION" "$COMMIT" "$SYNC_DATE" <<'PY'
import json
import sys
from pathlib import Path

root = Path(sys.argv[1])
upstream_version = sys.argv[2]
package_version = sys.argv[3]
commit = sys.argv[4]
sync_date = sys.argv[5]

codex_manifest_path = root / "plugins/kami/.codex-plugin/plugin.json"
codex_manifest = json.loads(codex_manifest_path.read_text())
codex_manifest["version"] = package_version
codex_manifest_path.write_text(json.dumps(codex_manifest, indent=2, ensure_ascii=False) + "\n")

claude_plugin = {
    "name": "kami",
    "displayName": "Kami",
    "description": "Typeset professional documents and landing pages using the Kami design system.",
    "version": package_version,
    "author": {
        "name": "Tw93",
        "email": "hitw93@gmail.com",
        "url": "https://github.com/tw93",
    },
    "homepage": "https://github.com/tw93/Kami",
    "license": "MIT",
}
(root / "plugins/kami/.claude-plugin/plugin.json").write_text(
    json.dumps(claude_plugin, indent=2, ensure_ascii=False) + "\n"
)

source_md = f"""# Kami Source

- Upstream repository: https://github.com/tw93/Kami
- Mirrored commit: `{commit}`
- Upstream version: `{upstream_version}`
- Local package version: `{package_version}`
- License: MIT, see `skills/kami/LICENSE`
- Last synced: {sync_date}

This plugin is mirrored from the upstream packaged plugin at
`plugins/kami` in `tw93/Kami`. Run `scripts/sync-kami.sh` to refresh it.
"""
(root / "plugins/kami/SOURCE.md").write_text(source_md)

claude_marketplace_path = root / ".claude-plugin/marketplace.json"
claude_marketplace = json.loads(claude_marketplace_path.read_text())
claude_entry = {
    "name": "kami",
    "source": "./plugins/kami",
    "description": "Typeset professional documents and landing pages using the Kami design system.",
    "version": package_version,
    "category": "documents",
    "homepage": "https://github.com/tw93/Kami",
    "author": {
        "name": "Tw93",
        "email": "hitw93@gmail.com",
        "url": "https://github.com/tw93",
    },
}

codex_marketplace_path = root / ".agents/plugins/marketplace.json"
codex_marketplace = json.loads(codex_marketplace_path.read_text())
codex_entry = {
    "name": "kami",
    "source": {
        "source": "local",
        "path": "./plugins/kami",
    },
    "description": "Typeset professional documents and landing pages using the Kami design system.",
    "version": package_version,
    "category": "Productivity",
    "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL",
    },
}

def upsert_plugin(marketplace, entry):
    plugins = marketplace.setdefault("plugins", [])
    for index, plugin in enumerate(plugins):
        if plugin.get("name") == entry["name"]:
            plugins[index] = entry
            break
    else:
        plugins.append(entry)

upsert_plugin(claude_marketplace, claude_entry)
upsert_plugin(codex_marketplace, codex_entry)

claude_marketplace_path.write_text(json.dumps(claude_marketplace, indent=2, ensure_ascii=False) + "\n")
codex_marketplace_path.write_text(json.dumps(codex_marketplace, indent=2, ensure_ascii=False) + "\n")
PY

find "$ROOT_DIR/plugins/kami" -name .DS_Store -delete

echo "Kami sync complete. Review README.md, AGENTS.md, and CLAUDE.md if upstream purpose or install behavior changed."
