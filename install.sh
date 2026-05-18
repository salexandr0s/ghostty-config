#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config/ghostty"
BACKUP_SUFFIX=".bak-$(date +%Y%m%d%H%M%S)"

link() {
  local src="$1" dst="$2"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "  ok  $dst"
    return
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    rm -rf "${dst}${BACKUP_SUFFIX}"
    mv "$dst" "${dst}${BACKUP_SUFFIX}"
    echo "  bak $dst"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "  ln  $dst -> $src"
}

echo "Installing ghostty-config..."
mkdir -p "$CONFIG_DIR"

link "$REPO_DIR/config" "$CONFIG_DIR/config"
link "$REPO_DIR/shaders" "$CONFIG_DIR/shaders"

echo "Done. Reload Ghostty with Cmd+Shift+, or restart it."
