# Zellij Cheatsheet

Terminal multiplexer. Config: `~/.config/zellij/`

## Modes

Zellij uses modes (like vim). Default prefix: `Ctrl+g` to enter locked mode, or use mode keys directly.

| Mode | Key | Purpose |
|------|-----|---------|
| Normal | default | Regular terminal input |
| Pane | `Ctrl+p` | Pane management |
| Tab | `Ctrl+t` | Tab management |
| Resize | `Ctrl+n` | Resize panes |
| Scroll | `Ctrl+s` | Scroll/search output |
| Session | `Ctrl+o` | Session management |

Press `Esc` or `Enter` to return to Normal mode.

## Panes (Ctrl+p, then...)

| Key | Action |
|-----|--------|
| `n` | New pane (right) |
| `d` | New pane (down) |
| `x` | Close pane |
| `f` | Toggle fullscreen |
| `h` `j` `k` `l` | Move focus |
| `w` | Toggle floating pane |

## Tabs (Ctrl+t, then...)

| Key | Action |
|-----|--------|
| `n` | New tab |
| `x` | Close tab |
| `r` | Rename tab |
| `h` / `l` | Previous/Next tab |
| `1-9` | Go to tab N |

## Resize (Ctrl+n, then...)

| Key | Action |
|-----|--------|
| `h` `j` `k` `l` | Resize in direction |
| `+` / `-` | Increase/decrease |

## Scroll Mode (Ctrl+s)

| Key | Action |
|-----|--------|
| `j` / `k` | Scroll down/up |
| `d` / `u` | Half page down/up |
| `/` | Search |
| `n` / `N` | Next/previous match |
| `e` | Edit scrollback in $EDITOR |

## Sessions (Ctrl+o, then...)

| Key | Action |
|-----|--------|
| `d` | Detach |
| `w` | Session manager |

## Quick Commands

```bash
zellij                     # Start new session
zellij attach              # Attach to running session
zellij attach -c name      # Attach or create named session
zellij list-sessions       # List sessions
zellij kill-session name   # Kill session
```

## Layouts

```bash
zellij --layout default    # Use default layout
zellij --layout compact    # Minimal status bar
```

## Tips

- `Ctrl+p` then `z` toggles pane zoom (fullscreen current pane)
- Session names auto-generate; use `-c name` to reattach easily
- Floating panes (`Ctrl+p` then `w`) are great for quick commands
- Status bar shows available keybindings for current mode
