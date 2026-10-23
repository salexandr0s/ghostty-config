#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config/ghostty"
BACKUP_SUFFIX=".bak-$(date +%Y%m%d%H%M%S)"

link() {
  local src="$1" dst="$2"
  local backup_dir="" backup_item=""

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "  ok  $dst"
    return 0
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if ! backup_dir=$(mktemp -d "${dst}${BACKUP_SUFFIX}.XXXXXX"); then
      printf '  err could not reserve backup for %s; result: %s\n' "$dst" "${backup_dir:-<empty>}" >&2
      return 1
    fi
    if [ -z "$backup_dir" ]; then
      printf '  err empty backup reservation for %s\n' "$dst" >&2
      return 1
    fi
    case "$backup_dir" in
      "${dst}${BACKUP_SUFFIX}."??????) ;;
      *)
        printf '  err invalid backup reservation for %s: %s\n' "$dst" "${backup_dir:-<empty>}" >&2
        return 1
        ;;
    esac
    if [ "$(dirname "$backup_dir")" != "$(dirname "$dst")" ] ||
       [ ! -d "$backup_dir" ] || [ -L "$backup_dir" ] || [ ! -O "$backup_dir" ] ||
       [ "$(find "$backup_dir" -prune -type d -perm 700 -print)" != "$backup_dir" ]; then
      printf '  err backup reservation is not a private same-parent directory: %s\n' "$backup_dir" >&2
      return 1
    fi
    backup_item="$backup_dir/original"
    if [ -e "$backup_item" ] || [ -L "$backup_item" ] || ! mv "$dst" "$backup_item"; then
      printf '  err could not back up %s; reservation retained at %s\n' "$dst" "$backup_dir" >&2
      return 1
    fi
    printf '  bak %s -> %s\n' "$dst" "$backup_item"
  fi

  if ! mkdir -p "$(dirname "$dst")"; then
    printf '  err could not create parent for %s%s\n' "$dst" "${backup_item:+; recover previous item at $backup_item}" >&2
    return 1
  fi
  if ! ln -s "$src" "$dst"; then
    printf '  err could not link %s%s\n' "$dst" "${backup_item:+; recover previous item at $backup_item}" >&2
    return 1
  fi
  echo "  ln  $dst -> $src"
  return 0
}

echo "Installing ghostty-config..."
mkdir -p "$CONFIG_DIR"

link "$REPO_DIR/config" "$CONFIG_DIR/config"
link "$REPO_DIR/shaders" "$CONFIG_DIR/shaders"

echo "Done. Reload Ghostty with Cmd+Shift+, or restart it."
