#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════╗"
echo "║          Dotfiles Installer           ║"
echo "╚═══════════════════════════════════════╝"
echo -e "${NC}"

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)
            if grep -qi microsoft /proc/version 2>/dev/null; then
                echo "wsl"
            else
                echo "linux"
            fi
            ;;
        Darwin*)
            echo "macos"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

OS=$(detect_os)
echo -e "${BLUE}Detected OS:${NC} $OS"

# Create symlink (backs up existing file)
link_file() {
    local src=$1
    local dst=$2

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        if [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
            echo -e "${GREEN}[LINKED]${NC} $dst"
            return
        fi
        local backup="${dst}.backup.$(date +%Y%m%d%H%M%S)"
        mv "$dst" "$backup"
        echo -e "${YELLOW}[BACKUP]${NC} $dst -> $backup"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    echo -e "${GREEN}[LINKED]${NC} $dst -> $src"
}

# Symlink dotfiles
echo -e "\n${BLUE}━━━ Symlinking Dotfiles ━━━${NC}"

link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
link_file "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
link_file "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Run platform-specific installer
echo -e "\n${BLUE}━━━ Platform Setup ━━━${NC}"

case "$OS" in
    wsl|linux)
        if [ -f "$DOTFILES_DIR/scripts/linux.sh" ]; then
            echo -e "${YELLOW}Run platform installer?${NC}"
            read -p "[y/N]: " response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                bash "$DOTFILES_DIR/scripts/linux.sh"
            fi
        fi
        ;;
    macos)
        if [ -f "$DOTFILES_DIR/scripts/macos.sh" ]; then
            echo -e "${YELLOW}Run platform installer?${NC}"
            read -p "[y/N]: " response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                bash "$DOTFILES_DIR/scripts/macos.sh"
            fi
        fi
        ;;
esac

echo -e "\n${GREEN}╔═══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Dotfiles Installed!          ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════╝${NC}"
echo -e "\n${YELLOW}Restart your terminal or run:${NC} exec zsh"
