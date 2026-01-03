# Yazi Cheatsheet

Terminal file manager. Config: `~/.config/yazi/`

## Navigation

| Key | Action |
|-----|--------|
| `h` `j` `k` `l` | Left/Down/Up/Right (vim-style) |
| `gg` | Go to top |
| `G` | Go to bottom |
| `~` | Go to home |
| `-` | Go to parent |

## Pane Resizing

| Key | Action |
|-----|--------|
| `[` | Decrease parent pane width |
| `]` | Increase parent pane width |
| `{` | Decrease preview pane width |
| `}` | Increase preview pane width |

Config ratio in `yazi.toml`:
```toml
[mgr]
ratio = [2, 2, 4]  # parent : current : preview
```

## Search & Jump

| Key | Action |
|-----|--------|
| `/` | Search in current directory |
| `f` | Filter current view |
| `z` | Zoxide jump (fuzzy history) |
| `s` | Search with fd (recursive) |
| `:cd <path>` | Direct path navigation |

## File Operations

| Key | Action |
|-----|--------|
| `y` | Yank (copy) |
| `x` | Cut |
| `p` | Paste |
| `d` | Trash |
| `D` | Permanent delete |
| `a` | Create file |
| `A` | Create directory |
| `r` | Rename |
| `Space` | Toggle selection |

## Custom Shortcuts (dotfiles)

| Key | Action |
|-----|--------|
| `gd` | Go to ~/Downloads |
| `gs` | Go to ~/source |
| `gc` | Go to ~/.config |

## Preview

| Key | Action |
|-----|--------|
| `Tab` | Toggle preview pane |
| `.` | Toggle hidden files |

Wrap is config-only (no runtime toggle):
```toml
[preview]
wrap = "yes"  # Wrap long lines in preview
```

## Custom Plugins (dotfiles)

**HTML Preview** — renders HTML as text using `w3m`
- Requires: `brew install w3m` (macOS) or `sudo apt install w3m` (Linux/WSL)
- Files: `*.html`, `*.htm`

## Tips

- Zoxide (`z`) learns from shell cd history — most useful for frequent folders
- `/` only searches current dir, use `s` for recursive search
- Preview pane shows file contents, images (with proper terminal support)
