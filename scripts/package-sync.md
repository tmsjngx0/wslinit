# Package Sync Workflow

Check installed packages against dotfiles package list and install missing ones.

## For Claude Code

When asked to sync packages, follow these steps per environment.

---

## macOS (Homebrew)

### Step 1: Get Required Packages from List

```bash
# Extract required brew packages (between first ``` and ```)
grep -A100 "## Required (brew)" ~/source/dotfiles/packages/macos.md | \
  sed -n '/```/,/```/p' | grep -v '```' | grep -v '^#' | grep -v '^$' | \
  sed 's/#.*//' | tr -d ' ' | sort -u
```

### Step 2: Get Currently Installed

```bash
brew leaves | sort
```

### Step 3: Find Missing (Delta)

```bash
# Required but not installed
comm -23 \
  <(grep -A100 "## Required (brew)" ~/source/dotfiles/packages/macos.md | \
    sed -n '/```/,/```/p' | grep -v '```' | grep -v '^#' | grep -v '^$' | \
    sed 's/#.*//' | tr -d ' ' | sort -u) \
  <(brew leaves | sort)
```

### Step 4: Install Missing

```bash
# Install all missing at once
brew install $(comm -23 \
  <(grep -A100 "## Required (brew)" ~/source/dotfiles/packages/macos.md | \
    sed -n '/```/,/```/p' | grep -v '```' | grep -v '^#' | grep -v '^$' | \
    sed 's/#.*//' | tr -d ' ' | sort -u) \
  <(brew leaves | sort) | tr '\n' ' ')
```

### Casks

```bash
# Required casks
grep -A20 "## Required (cask)" ~/source/dotfiles/packages/macos.md | \
  sed -n '/```/,/```/p' | grep -v '```' | grep -v '^#' | grep -v '^$' | \
  sed 's/#.*//' | tr -d ' ' | sort -u

# Installed casks
brew list --cask | sort

# Install missing casks
brew install --cask <missing-cask>
```

### npm Global Packages

```bash
# Required npm packages
grep -A10 "## Required (npm global)" ~/source/dotfiles/packages/macos.md | \
  sed -n '/```/,/```/p' | grep -v '```' | grep -v '^#' | grep -v '^$' | \
  sed 's/#.*//' | tr -d ' ' | sort -u

# Installed global npm
npm list -g --depth=0 2>/dev/null | tail -n +2 | awk '{print $2}' | sed 's/@.*//' | sort -u

# Install missing
npm install -g <package-name>
```

---

## Linux/WSL (apt + manual)

### Step 1: Get Required apt Packages

```bash
grep -A50 "## Required (apt)" ~/source/dotfiles/packages/linux.md | \
  sed -n '/```/,/```/p' | grep -v '```' | grep -v '^#' | grep -v '^$' | \
  sed 's/#.*//' | tr -d ' ' | sort -u
```

### Step 2: Check Installed

```bash
dpkg -l | grep '^ii' | awk '{print $2}' | sed 's/:.*$//' | sort -u
```

### Step 3: Find Missing

```bash
# Required but not installed
comm -23 \
  <(grep -A50 "## Required (apt)" ~/source/dotfiles/packages/linux.md | \
    sed -n '/```/,/```/p' | grep -v '```' | grep -v '^#' | grep -v '^$' | \
    sed 's/#.*//' | tr -d ' ' | sort -u) \
  <(dpkg -l | grep '^ii' | awk '{print $2}' | sed 's/:.*$//' | sort -u)
```

### Step 4: Install Missing

```bash
sudo apt update
sudo apt install -y <missing-packages>
```

### Manual Installs (check presence)

```bash
# Starship
command -v starship || curl -sS https://starship.rs/install.sh | sh

# fnm
command -v fnm || curl -fsSL https://fnm.vercel.app/install | bash

# uv
command -v uv || curl -LsSf https://astral.sh/uv/install.sh | sh

# yazi (check GitHub releases)
command -v yazi || echo "Install from: https://github.com/sxyazi/yazi/releases"
```

---

## Quick Summary Commands

### macOS - Show delta only
```bash
echo "=== Missing brew packages ===" && \
comm -23 \
  <(grep -A100 "## Required (brew)" ~/source/dotfiles/packages/macos.md | \
    sed -n '/```/,/```/p' | grep -v '```' | grep -v '^#' | grep -v '^$' | \
    sed 's/#.*//' | tr -d ' ' | sort -u) \
  <(brew leaves | sort)
```

### Linux - Show delta only
```bash
echo "=== Missing apt packages ===" && \
comm -23 \
  <(grep -A50 "## Required (apt)" ~/source/dotfiles/packages/linux.md | \
    sed -n '/```/,/```/p' | grep -v '```' | grep -v '^#' | grep -v '^$' | \
    sed 's/#.*//' | tr -d ' ' | sort -u) \
  <(dpkg -l | grep '^ii' | awk '{print $2}' | sed 's/:.*$//' | sort -u)
```

---

## Notes

- Run delta check after pulling dotfiles updates
- Some packages have different names: `fd` (brew) vs `fd-find` (apt)
- Manual section items need individual commands (starship, fnm, uv, yazi)
- Optional packages are intentionally excluded from sync
