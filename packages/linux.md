# Linux/WSL Packages

> Last scanned: 2026-01-03 (WSL Ubuntu)

## Required (apt)

```
# CLI essentials
git
git-lfs
gh
fzf
ripgrep
fd-find
jq
tree
zoxide

# Terminal
zellij
neovim
lazygit

# Build tools
build-essential
curl
wget
unzip

# WSL utilities
wslu
```

## Required (manual/script)

```
# Starship prompt
curl -sS https://starship.rs/install.sh | sh

# fnm (Node.js)
curl -fsSL https://fnm.vercel.app/install | bash

# uv (Python)
curl -LsSf https://astral.sh/uv/install.sh | sh

# .NET
# https://learn.microsoft.com/dotnet/core/install/linux

# Claude Code
npm install -g @anthropic-ai/claude-code

# Yazi (terminal file manager)
# https://github.com/sxyazi/yazi/releases
```

## Optional

```
go
rustup
docker-ce
delta           # Better git diff viewer

# Yazi dependencies (file manager previews)
ffmpeg
7zip
poppler-utils   # PDF preview
imagemagick     # Image preview
w3m             # HTML preview
```

## Currently Installed (2026-01-03)

### Core CLI
- git, git-lfs, gh, zsh, fzf, ripgrep, fd-find, jq, tree, zoxide, tmux

### Terminal Tools (GitHub releases → /usr/local/bin)
- neovim v0.11.5 (→ /opt/nvim-linux-x86_64)
- zellij, lazygit, yazi, delta

### Runtimes
- fnm 1.38.1 + Node v22.21.1
- bun (~/.bun)
- uv (~/.local/bin)
- dotnet 8.0, 9.0

### Cloud CLIs
- az (Azure CLI)
- gh (GitHub CLI)

### npm Global Packages
- @anthropic-ai/claude-code
- @fission-ai/openspec
- @openai/codex

### Yazi Preview Dependencies
- ffmpeg, 7z, imagemagick, poppler-utils
