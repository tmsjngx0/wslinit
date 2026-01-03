#!/bin/bash

set -e

# Parse args
AUTO_YES=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -y|--yes) AUTO_YES=true; shift ;;
        *) shift ;;
    esac
done

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
link_file "$DOTFILES_DIR/yazi" "$HOME/.config/yazi"

# WSL-specific setup (requires sudo, can't symlink to /etc)
if [ "$OS" = "wsl" ]; then
    echo -e "\n${BLUE}━━━ WSL Configuration ━━━${NC}"
    if [ -f "$DOTFILES_DIR/wsl/wsl.conf" ]; then
        if ! diff -q "$DOTFILES_DIR/wsl/wsl.conf" /etc/wsl.conf >/dev/null 2>&1; then
            if $AUTO_YES; then
                response="y"
            else
                echo -e "${YELLOW}Update /etc/wsl.conf?${NC}"
                read -p "[y/N]: " response
            fi
            if [[ "$response" =~ ^[Yy]$ ]]; then
                sudo cp "$DOTFILES_DIR/wsl/wsl.conf" /etc/wsl.conf
                echo -e "${GREEN}[COPIED]${NC} /etc/wsl.conf"
                echo -e "${YELLOW}Run 'wsl --shutdown' in PowerShell to apply changes${NC}"
            fi
        else
            echo -e "${GREEN}[OK]${NC} /etc/wsl.conf is up to date"
        fi
    fi
fi

# Run platform-specific installer
echo -e "\n${BLUE}━━━ Platform Setup ━━━${NC}"

case "$OS" in
    wsl|linux)
        if [ -f "$DOTFILES_DIR/scripts/linux.sh" ]; then
            if $AUTO_YES; then
                bash "$DOTFILES_DIR/scripts/linux.sh" -y
            else
                echo -e "${YELLOW}Run platform installer?${NC}"
                read -p "[y/N]: " response
                if [[ "$response" =~ ^[Yy]$ ]]; then
                    bash "$DOTFILES_DIR/scripts/linux.sh"
                fi
            fi
        fi
        ;;
    macos)
        if [ -f "$DOTFILES_DIR/scripts/macos.sh" ]; then
            if $AUTO_YES; then
                bash "$DOTFILES_DIR/scripts/macos.sh" -y
            else
                echo -e "${YELLOW}Run platform installer?${NC}"
                read -p "[y/N]: " response
                if [[ "$response" =~ ^[Yy]$ ]]; then
                    bash "$DOTFILES_DIR/scripts/macos.sh"
                fi
            fi
        fi
        ;;
esac

echo -e "\n${GREEN}╔═══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Dotfiles Installed!          ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════╝${NC}"
echo -e "\n${YELLOW}Restart your terminal or run:${NC} exec zsh"
