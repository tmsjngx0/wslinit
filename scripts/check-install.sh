#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════╗"
echo "║       Installation Status Check       ║"
echo "╚═══════════════════════════════════════╝"
echo -e "${NC}"

MISSING=0
INSTALLED=0

check() {
    local name=$1
    local cmd=$2
    local version_cmd=${3:-"--version"}

    if command -v "$cmd" &> /dev/null; then
        local ver=$($cmd $version_cmd 2>&1 | head -1)
        echo -e "${GREEN}[OK]${NC} $name: $ver"
        ((INSTALLED++))
    else
        echo -e "${RED}[MISSING]${NC} $name"
        ((MISSING++))
    fi
}

check_path() {
    local name=$1
    local path=$2
    local version_cmd=${3:-"--version"}

    if [[ -x "$path" ]]; then
        local ver=$($path $version_cmd 2>&1 | head -1)
        echo -e "${GREEN}[OK]${NC} $name: $ver"
        ((INSTALLED++))
    else
        echo -e "${RED}[MISSING]${NC} $name (expected at $path)"
        ((MISSING++))
    fi
}

check_dir() {
    local name=$1
    local path=$2

    if [[ -d "$path" ]]; then
        echo -e "${GREEN}[OK]${NC} $name"
        ((INSTALLED++))
    else
        echo -e "${RED}[MISSING]${NC} $name"
        ((MISSING++))
    fi
}

echo -e "${BLUE}━━━ Shell ━━━${NC}"
check "zsh" "zsh"
check_dir "Oh My Zsh" "$HOME/.oh-my-zsh"
check_dir "zsh-autosuggestions" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
check_dir "zsh-syntax-highlighting" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
check "starship" "starship"

echo -e "\n${BLUE}━━━ Editors & Tools ━━━${NC}"
check_path "neovim" "/opt/nvim-linux-x86_64/bin/nvim"
check "lazygit" "lazygit" "--version"
check "yazi" "yazi" "--version"
check "zellij" "zellij" "--version"
check "delta" "delta" "--version"

echo -e "\n${BLUE}━━━ Node.js ━━━${NC}"
check "fnm" "fnm"
check "node" "node"
check "npm" "npm"
check "bun" "bun"

echo -e "\n${BLUE}━━━ Python ━━━${NC}"
check "uv" "uv"
check "python3" "python3"

echo -e "\n${BLUE}━━━ .NET ━━━${NC}"
if command -v dotnet &> /dev/null; then
    echo -e "${GREEN}[OK]${NC} dotnet:"
    dotnet --list-sdks 2>/dev/null | sed 's/^/     /'
    ((INSTALLED++))
else
    echo -e "${RED}[MISSING]${NC} dotnet"
    ((MISSING++))
fi

echo -e "\n${BLUE}━━━ Containers ━━━${NC}"
check "docker" "docker"

echo -e "\n${BLUE}━━━ CLI Tools ━━━${NC}"
check "gh (GitHub CLI)" "gh"
check "az (Azure CLI)" "az"
check "claude" "claude"

echo -e "\n${BLUE}━━━ System ━━━${NC}"
check "git" "git"
check "curl" "curl"
check "jq" "jq"
check "ripgrep" "rg"
check "fd" "fdfind"
check "fzf" "fzf"
check "zoxide" "zoxide"
check "xclip" "xclip"
check "wl-copy" "wl-copy"

echo -e "\n${BLUE}━━━ Dotfiles ━━━${NC}"
for f in .zshrc .gitconfig; do
    if [[ -L "$HOME/$f" ]]; then
        echo -e "${GREEN}[LINKED]${NC} ~/$f -> $(readlink $HOME/$f)"
    elif [[ -f "$HOME/$f" ]]; then
        echo -e "${YELLOW}[FILE]${NC} ~/$f (not a symlink)"
    else
        echo -e "${RED}[MISSING]${NC} ~/$f"
    fi
done

for f in starship.toml nvim yazi; do
    if [[ -L "$HOME/.config/$f" ]]; then
        echo -e "${GREEN}[LINKED]${NC} ~/.config/$f"
    elif [[ -e "$HOME/.config/$f" ]]; then
        echo -e "${YELLOW}[EXISTS]${NC} ~/.config/$f (not a symlink)"
    else
        echo -e "${RED}[MISSING]${NC} ~/.config/$f"
    fi
done

echo -e "\n${BLUE}════════════════════════════════════════${NC}"
echo -e "Installed: ${GREEN}$INSTALLED${NC}  Missing: ${RED}$MISSING${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"

exit $MISSING
