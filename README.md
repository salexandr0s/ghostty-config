# Ghostty Config

My [Ghostty](https://ghostty.org) terminal configuration — optimized for a clean, productive workflow with split-based navigation.

This repo is intentionally limited to terminal-emulator appearance and behavior. Assistant-native status lines, hooks, and output styles live in `ai-config`; launcher scripts and completion sounds live in `terminal-config`.

## What's included

```
ghostty-config/
├── config              # Main Ghostty configuration
├── install.sh          # Idempotent symlink installer
├── shaders/
│   └── crt.glsl        # Optional CRT scanline + vignette shader
└── README.md
```

## Installation

```bash
git clone https://github.com/salexandr0s/ghostty-config.git ~/GitHub/ghostty-config
cd ~/GitHub/ghostty-config
./install.sh

# Reload Ghostty (Cmd+Shift+,) or restart it
```

## Overview

### Font

- **JetBrains Mono Nerd Font** at size 12, thickened for clarity

### Theme

- **Ayu** — a warm, easy-on-the-eyes color scheme
- Dark window chrome regardless of system appearance

### Window

- Slightly transparent background (95% opacity) with blur
- Tab-style titlebar (macOS)
- Window state is saved and restored between sessions

### Cursor & Mouse

- Bar cursor with blinking
- Mouse hides while typing
- Copy-on-select to clipboard

### Quick Terminal

- Quake-style dropdown terminal from the top of the screen
- Follows your mouse to whichever display you're on
- Auto-hides when it loses focus

### AI Workflow Boundary

- Claude and Codex notifications are triggered outside Ghostty via `terminal-config/bin/ai-notify`
- Claude status line and Codex footer are configured in `ai-config`
- Ghostty stays responsible for shell integration, visuals, and keybindings only

## Keyboard Shortcuts

The keybinds follow a **SAND** mnemonic: **S**plit, **A**cross, **N**avigate, **D**estroy.

| Action                               | Shortcut          |
| ------------------------------------ | ----------------- |
| **Split right**                      | `Cmd+D`           |
| **Split down**                       | `Cmd+Shift+D`     |
| **New tab**                          | `Cmd+T`           |
| **Previous tab**                     | `Cmd+Shift+Left`  |
| **Next tab**                         | `Cmd+Shift+Right` |
| **Go to split (left/right/up/down)** | `Cmd+Alt+Arrow`   |
| **Equalize splits**                  | `Cmd+Shift+E`     |
| **Zoom split (toggle)**              | `Cmd+Shift+F`     |
| **Open config**                      | `Cmd+Shift+P`     |
| **Close pane**                       | `Cmd+W`           |
| **Increase font**                    | `Cmd++`           |
| **Decrease font**                    | `Cmd+-`           |
| **Reset font size**                  | `Cmd+0`           |
| **Toggle quick terminal**            | `Ctrl+`` `        |
| **Reload config**                    | `Cmd+Shift+,`     |

## CRT Shader (optional)

A subtle retro CRT effect with faint scanlines and a soft vignette. To enable it, add this line to your `config`:

```
custom-shader = ~/.config/ghostty/shaders/crt.glsl
```

## Requirements

- [Ghostty](https://ghostty.org) terminal
- [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads) installed on your system
