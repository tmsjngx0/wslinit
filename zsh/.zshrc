# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme (ignored when using starship)
ZSH_THEME=""

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# ============================================
# PATH
# ============================================

# Neovim
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# .NET
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

# fnm (Node.js)
if [ -d "$HOME/.local/share/fnm" ]; then
    export PATH="$HOME/.local/share/fnm:$PATH"
    eval "$(fnm env)"
fi

# Bun
if [ -d "$HOME/.bun" ]; then
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"  # completions
fi

# uv (Python)
if [ -f "$HOME/.local/bin/env" ]; then
    source "$HOME/.local/bin/env"
fi

# Homebrew (macOS)
if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ============================================
# Aliases
# ============================================

alias vim="nvim"
alias v="nvim"
alias lg="lazygit"
alias zj="zellij"
alias ll="ls -la"
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline"

# ============================================
# Machine-specific config (not tracked in git)
# ============================================
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ============================================
# Starship prompt (load last)
# ============================================
eval "$(starship init zsh)"
