# Zshrc Migration Workflow

Migrate from a single `.zshrc` to symlinked base + local overrides pattern.

## Pattern

```
~/.zshrc           →  symlink to dotfiles/zsh/.zshrc (shared)
~/.zshrc.local     →  machine-specific (gitignored)
```

## Automated Migration

### Step 1: Backup

```bash
cp ~/.zshrc ~/.zshrc.bak.$(date +%Y%m%d)
```

### Step 2: Analyze Differences

See what's in your current `.zshrc` that's NOT in dotfiles:

```bash
# Side-by-side diff
diff --color -y ~/source/dotfiles/zsh/.zshrc ~/.zshrc | less

# Or unified diff
diff --color -u ~/source/dotfiles/zsh/.zshrc ~/.zshrc
```

Lines unique to your local file (potential candidates for .zshrc.local):
```bash
comm -13 <(grep -v '^[[:space:]]*#' ~/source/dotfiles/zsh/.zshrc | grep -v '^$' | sort -u) \
         <(grep -v '^[[:space:]]*#' ~/.zshrc | grep -v '^$' | sort -u)
```

### Step 3: Auto-Extract Local Lines

```bash
# Create .zshrc.local with unique local lines
{
  echo "# Machine-specific zsh configuration"
  echo "# Auto-generated from migration diff on $(date +%Y-%m-%d)"
  echo "# Review and organize as needed"
  echo ""
  comm -13 <(grep -v '^[[:space:]]*#' ~/source/dotfiles/zsh/.zshrc | grep -v '^$' | sort -u) \
           <(grep -v '^[[:space:]]*#' ~/.zshrc | grep -v '^$' | sort -u)
} > ~/.zshrc.local

echo "Created ~/.zshrc.local:"
cat ~/.zshrc.local
```

### Step 4: Review Generated Local File

Review `~/.zshrc.local` and remove:
- Lines that belong in shared config
- Duplicates or obsolete settings

```bash
cat ~/.zshrc.local
# Edit with your preferred editor if needed
```

### Step 5: Apply Symlink

```bash
cd ~/source/dotfiles
./install.sh
```

### Step 6: Verify

```bash
# Check symlink created
ls -la ~/.zshrc

# Reload and test
exec zsh

# Verify local file is sourced (line 71 in base)
grep "zshrc.local" ~/.zshrc
```

## Quick One-Liner

Backup + extract + install in one go:

```bash
cp ~/.zshrc ~/.zshrc.bak && \
comm -13 <(sort -u ~/source/dotfiles/zsh/.zshrc) <(sort -u ~/.zshrc) > ~/.zshrc.local && \
cd ~/source/dotfiles && ./install.sh && exec zsh
```

## Reverting

```bash
rm ~/.zshrc
cp ~/.zshrc.bak ~/.zshrc
rm ~/.zshrc.local  # optional
```

## Notes

- Base `.zshrc` sources `~/.zshrc.local` at line 71 if it exists
- Keep secrets/API keys only in `.zshrc.local` (not version controlled)
- Re-run diff after updating dotfiles zshrc to catch new deltas
