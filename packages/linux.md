# Linux/WSL Packages

> Last scanned: TODO

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

# Yazi dependencies (file manager previews)
ffmpeg
7zip
poppler-utils   # PDF preview
imagemagick     # Image preview
```

## Currently Installed (reference)

<details>
<summary>apt list --installed (TODO)</summary>

```
# Run: apt list --installed 2>/dev/null | grep -E "^(git|gh|fzf|ripgrep)"
```

</details>
