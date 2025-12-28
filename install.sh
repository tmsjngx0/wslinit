#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if command exists
is_installed() {
    command -v "$1" &> /dev/null
}

# Ask y/n
ask() {
    local prompt=$1
    local default=${2:-n}

    if [[ "$default" == "y" ]]; then
        echo -e -n "${YELLOW}$prompt [Y/n]: ${NC}"
    else
        echo -e -n "${YELLOW}$prompt [y/N]: ${NC}"
    fi

    read -r response
    response=${response:-$default}
    [[ "$response" =~ ^[Yy]$ ]]
}

# Print section header
section() {
    echo -e "\n${BLUE}━━━ $1 ━━━${NC}"
}

# Print status
status() {
    if is_installed "$2"; then
        echo -e "${GREEN}[INSTALLED]${NC} $1"
        return 0
    else
        echo -e "${RED}[MISSING]${NC} $1"
        return 1
    fi
}

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════╗"
echo "║     WSL2 Development Setup Script     ║"
echo "╚═══════════════════════════════════════╝"
echo -e "${NC}"

# 1. Sudo nopasswd
section "Sudo Nopasswd"
if sudo -n true 2>/dev/null; then
    echo -e "${GREEN}[CONFIGURED]${NC} Passwordless sudo"
else
    echo -e "${RED}[NOT SET]${NC} Passwordless sudo"
    if ask "Configure sudo nopasswd?"; then
        echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER > /dev/null
        echo -e "${GREEN}Done${NC}"
    fi
fi

# 2. APT packages
section "APT Packages"
MISSING_APT=()
for pkg in build-essential curl wget git unzip zip jq zsh; do
    dpkg -s "$pkg" &> /dev/null || MISSING_APT+=("$pkg")
done

if [[ ${#MISSING_APT[@]} -eq 0 ]]; then
    echo -e "${GREEN}[INSTALLED]${NC} All essential packages"
else
    echo -e "${RED}[MISSING]${NC} ${MISSING_APT[*]}"
    if ask "Install APT packages (build-essential, git, zsh, jq, ripgrep, fzf, java)?"; then
        sudo apt update && sudo apt upgrade -y
        sudo apt install -y build-essential curl wget ca-certificates git unzip zip \
            pkg-config software-properties-common htop tree jq ripgrep fd-find fzf zsh openjdk-8-jdk
        echo -e "${GREEN}Done${NC}"
    fi
fi

# 3. Zsh as default
section "Zsh Default Shell"
if [[ "$SHELL" == *"zsh"* ]]; then
    echo -e "${GREEN}[SET]${NC} Zsh is default shell"
else
    echo -e "${RED}[NOT SET]${NC} Default shell is $SHELL"
    if ask "Set zsh as default shell?"; then
        chsh -s "$(which zsh)"
        echo -e "${GREEN}Done - restart terminal to take effect${NC}"
    fi
fi

# 4. Oh My Zsh
section "Oh My Zsh"
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo -e "${GREEN}[INSTALLED]${NC} Oh My Zsh"
else
    echo -e "${RED}[MISSING]${NC} Oh My Zsh"
    if ask "Install Oh My Zsh?"; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        echo -e "${GREEN}Done${NC}"
    fi
fi

# 5. Zsh plugins
section "Zsh Plugins"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" && -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    echo -e "${GREEN}[INSTALLED]${NC} zsh-autosuggestions, zsh-syntax-highlighting"
else
    echo -e "${RED}[MISSING]${NC} Zsh plugins"
    if ask "Install zsh-autosuggestions & zsh-syntax-highlighting?"; then
        [[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] || \
            git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        [[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]] || \
            git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        echo -e "${GREEN}Done${NC}"
        echo -e "${YELLOW}Update ~/.zshrc: plugins=(git zsh-autosuggestions zsh-syntax-highlighting)${NC}"
    fi
fi

# 6. Starship
section "Starship Prompt"
if status "Starship" "starship"; then :; else
    if ask "Install Starship?"; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y
        echo -e "${GREEN}Done${NC}"
        echo -e "${YELLOW}Add to ~/.zshrc: eval \"\$(starship init zsh)\"${NC}"
    fi
fi

# 7. Neovim
section "Neovim"
if is_installed "nvim"; then
    NVIM_VER=$(nvim --version | head -1)
    echo -e "${GREEN}[INSTALLED]${NC} $NVIM_VER"
    if ask "Upgrade to latest Neovim?"; then
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        sudo rm -rf /opt/nvim-linux-x86_64
        sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
        rm nvim-linux-x86_64.tar.gz
        echo -e "${GREEN}Done${NC}"
        echo -e "${YELLOW}Add to ~/.zshrc: export PATH=\"\$PATH:/opt/nvim-linux-x86_64/bin\"${NC}"
    fi
else
    echo -e "${RED}[MISSING]${NC} Neovim"
    if ask "Install Neovim (latest)?"; then
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        sudo rm -rf /opt/nvim-linux-x86_64
        sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
        rm nvim-linux-x86_64.tar.gz
        echo -e "${GREEN}Done${NC}"
        echo -e "${YELLOW}Add to ~/.zshrc: export PATH=\"\$PATH:/opt/nvim-linux-x86_64/bin\"${NC}"
    fi
fi

# 8. fnm + Node
section "Node.js (fnm)"
if status "fnm" "fnm"; then
    node --version 2>/dev/null && echo -e "${GREEN}[INSTALLED]${NC} Node $(node --version)"
else
    if ask "Install fnm + Node LTS?"; then
        curl -fsSL https://fnm.vercel.app/install | bash
        export PATH="$HOME/.local/share/fnm:$PATH"
        eval "$(fnm env)"
        fnm install --lts
        echo -e "${GREEN}Done${NC}"
    fi
fi

# 9. uv (Python)
section "Python (uv)"
if status "uv" "uv"; then :; else
    if ask "Install uv?"; then
        curl -LsSf https://astral.sh/uv/install.sh | sh
        echo -e "${GREEN}Done${NC}"
    fi
fi

# 10. .NET
section ".NET (8, 9, 10)"
if is_installed "dotnet"; then
    echo -e "${GREEN}[INSTALLED]${NC}"
    dotnet --list-sdks
else
    echo -e "${RED}[MISSING]${NC} .NET"
    if ask "Install .NET 8, 9, 10?"; then
        curl -fsSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh
        chmod +x /tmp/dotnet-install.sh
        /tmp/dotnet-install.sh --channel 8.0
        /tmp/dotnet-install.sh --channel 9.0
        /tmp/dotnet-install.sh --channel 10.0
        rm /tmp/dotnet-install.sh
        echo -e "${GREEN}Done${NC}"
        echo -e "${YELLOW}Add to ~/.zshrc:${NC}"
        echo -e "${YELLOW}  export DOTNET_ROOT=\$HOME/.dotnet${NC}"
        echo -e "${YELLOW}  export PATH=\$PATH:\$DOTNET_ROOT:\$DOTNET_ROOT/tools${NC}"
    fi
fi

# 11. Docker
section "Docker"
if status "Docker" "docker"; then :; else
    if ask "Install Docker?"; then
        curl -fsSL https://get.docker.com | sh
        sudo usermod -aG docker $USER
        echo -e "${GREEN}Done${NC}"
        echo -e "${YELLOW}Log out and back in for group changes${NC}"
    fi
fi

# 12. GitHub CLI
section "GitHub CLI"
if status "GitHub CLI" "gh"; then :; else
    if ask "Install GitHub CLI?"; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg 2>/dev/null
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update && sudo apt install -y gh
        echo -e "${GREEN}Done${NC}"
        echo -e "${YELLOW}Run 'gh auth login' to authenticate${NC}"
    fi
fi

# 13. Azure CLI
section "Azure CLI"
if status "Azure CLI" "az"; then :; else
    if ask "Install Azure CLI?"; then
        curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
        echo -e "${GREEN}Done${NC}"
        echo -e "${YELLOW}Run 'az login' to authenticate${NC}"
    fi
fi

# 14. lazygit
section "lazygit"
if status "lazygit" "lazygit"; then :; else
    if ask "Install lazygit?"; then
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | jq -r '.tag_name' | sed 's/v//')
        curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
        sudo install /tmp/lazygit /usr/local/bin
        rm /tmp/lazygit /tmp/lazygit.tar.gz
        echo -e "${GREEN}Done${NC}"
    fi
fi

# 15. zellij
section "zellij"
if status "zellij" "zellij"; then :; else
    if ask "Install zellij?"; then
        curl -Lo /tmp/zellij.tar.gz https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz
        tar xf /tmp/zellij.tar.gz -C /tmp
        sudo install /tmp/zellij /usr/local/bin
        rm /tmp/zellij /tmp/zellij.tar.gz
        echo -e "${GREEN}Done${NC}"
    fi
fi

# 16. Claude Code
section "Claude Code"
if status "Claude Code" "claude"; then :; else
    if ask "Install Claude Code?"; then
        npm install -g @anthropic-ai/claude-code
        echo -e "${GREEN}Done${NC}"
    fi
fi

# Done
echo -e "\n${GREEN}╔═══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║            Setup Complete!            ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════╝${NC}"
echo -e "\n${YELLOW}Remember to:${NC}"
echo "  1. Restart your terminal or run 'exec zsh'"
echo "  2. Run 'gh auth login' if you installed GitHub CLI"
echo "  3. Run 'az login' if you installed Azure CLI"
echo ""
