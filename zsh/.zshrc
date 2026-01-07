# ============================================
# Oh My Zsh
# ============================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # Using starship instead
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

if [ -d "$ZSH" ]; then
    source $ZSH/oh-my-zsh.sh
fi

# ============================================
# PATH
# ============================================

# Neovim (bob version manager)
if [ -d "$HOME/.local/share/bob/nvim-bin" ]; then
    export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
# Fallback: Linux manual install
elif [ -d "/opt/nvim-linux-x86_64/bin" ]; then
    export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
fi

# .NET
if [ -d "$HOME/.dotnet" ]; then
    export DOTNET_ROOT=$HOME/.dotnet
    export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
fi

# fnm (Node.js)
[ -d "$HOME/.local/share/fnm" ] && export PATH="$HOME/.local/share/fnm:$PATH"
if command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"
fi

# Bun
if [ -d "$HOME/.bun" ]; then
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
fi

# uv (Python)
if [ -f "$HOME/.local/bin/env" ]; then
    source "$HOME/.local/bin/env"
fi

# Go
if [ -d "$HOME/go/bin" ]; then
    export PATH="$HOME/go/bin:$PATH"
fi

# Rust/Cargo
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Homebrew (macOS)
if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Snap (Linux/WSL)
if [ -d "/snap/bin" ]; then
    export PATH="/snap/bin:$PATH"
fi

# ============================================
# Aliases
# ============================================

# Editor (only if nvim installed)
if command -v nvim &> /dev/null; then
    alias vim="nvim"
    alias v="nvim"
fi

# Tools
alias lg="lazygit"
alias zj="zellij"
alias ll="ls -la"

# Git shortcuts
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline"

# Clipboard (OSC 52 - works over SSH)
osc-copy() {
  printf '\033]52;c;%s\a' "$(base64 | tr -d '\n')"
}
alias clip="osc-copy"

# ============================================
# Local config (machine-specific, not in git)
# ============================================
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ============================================
# Shell enhancements
# ============================================
# Zoxide - smarter cd command
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# ============================================
# Prompt (load last)
# ============================================
if command -v starship &> /dev/null; then
    # Use simplified config over SSH (avoids right_format cursor issues)
    if [[ -n "$SSH_CONNECTION" || -n "$SSH_TTY" ]]; then
        export STARSHIP_CONFIG="$HOME/.config/starship-ssh.toml"
    fi
    eval "$(starship init zsh)"
fi
