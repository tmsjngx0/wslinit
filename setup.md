# WSL2 Development Environment Setup

## 1. Sudo Nopasswd

```bash
sudo visudo
```

Add at the end (replace `username` with your username):
```
username ALL=(ALL) NOPASSWD: ALL
```

Or use this one-liner:
```bash
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
```

## 2. Update System

```bash
sudo apt update && sudo apt upgrade -y
```

## 3. Install Essential Packages

```bash
sudo apt install build-essential curl wget ca-certificates git unzip zip pkg-config software-properties-common htop tree jq ripgrep fd-find fzf zsh openjdk-8-jdk
```

### What's included:
| Package | Purpose |
|---------|---------|
| build-essential | C/C++ compiler and build tools |
| curl, wget | Download utilities |
| ca-certificates | SSL certificates |
| git | Version control |
| unzip, zip | Archive utilities |
| pkg-config | Library configuration |
| software-properties-common | PPA management |
| htop | Process viewer |
| tree | Directory visualization |
| jq | JSON processor |
| ripgrep | Fast search (rg) |
| fd-find | Fast file finder (fdfind) |
| fzf | Fuzzy finder |
| zsh | Z shell |
| openjdk-8-jdk | Java 8 |

## 4. Set Zsh as Default Shell

```bash
chsh -s "$(which zsh)"
exec zsh
```

## 5. Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## 6. Zsh Plugins

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Edit `~/.zshrc` and update the plugins line:
```bash
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```

## 7. Starship Prompt

```bash
curl -sS https://starship.rs/install.sh | sh
```

Add to the end of `~/.zshrc`:
```bash
eval "$(starship init zsh)"
```

Copy config:
```bash
mkdir -p ~/.config
cp starship.toml ~/.config/starship.toml
```

## 8. Neovim (Latest)

The apt version is outdated. Install latest from GitHub releases:

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz
```

Add to `~/.zshrc`:
```bash
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
```

## 9. Node.js (fnm)

```bash
curl -fsSL https://fnm.vercel.app/install | bash
source ~/.zshrc
fnm install --lts
```

## 10. Python (uv)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Add to `~/.zshrc` (if not auto-added):
```bash
source $HOME/.local/bin/env
```

## 11. .NET (8, 9, 10)

```bash
curl -fsSL https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh --channel 8.0
./dotnet-install.sh --channel 9.0
./dotnet-install.sh --channel 10.0
rm dotnet-install.sh
```

Add to `~/.zshrc`:
```bash
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
```

## 12. Docker

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
```

Log out and back in (or `newgrp docker`) for group changes to take effect.

## 13. GitHub CLI

```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
gh auth login
```

## 14. Azure CLI

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login
```

## 15. lazygit

```bash
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | jq -r '.tag_name' | sed 's/v//')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit lazygit.tar.gz
```

## 16. zellij

```bash
curl -LO https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz
tar xf zellij-x86_64-unknown-linux-musl.tar.gz
sudo install zellij /usr/local/bin
rm zellij zellij-x86_64-unknown-linux-musl.tar.gz
```

## 17. Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

## 18. SSH Keys

Generate separate keys for each service:

```bash
# GitHub (ed25519)
ssh-keygen -t ed25519 -C "thomasjeung@outlook.com" -f ~/.ssh/id_github

# Azure DevOps (RSA for compatibility)
ssh-keygen -t rsa -b 4096 -C "thomas@cadencesolutions.ca" -f ~/.ssh/id_azure
```

Create `~/.ssh/config`:
```
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_github

Host ssh.dev.azure.com
    HostName ssh.dev.azure.com
    User git
    IdentityFile ~/.ssh/id_azure
```

Start agent and add keys:
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_github
ssh-add ~/.ssh/id_azure
```

Copy public keys:
```bash
cat ~/.ssh/id_github.pub   # Add to https://github.com/settings/keys
cat ~/.ssh/id_azure.pub    # Add to https://dev.azure.com/_usersSettings/keys
```

Test connections:
```bash
ssh -T git@github.com
ssh -T git@ssh.dev.azure.com
```

---

## Next Steps (TODO)

- [ ] Git config (name, email)
- [ ] Dotfiles repo
