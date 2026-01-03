<!-- OPENSPEC:START -->
# OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:
- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:
- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->

# Dotfiles

개인 개발 환경 설정 통합 관리. macOS, Linux, WSL에서 일관된 개발 환경 유지.

## Quick Reference

```bash
./install.sh              # 전체 설치 (symlinks + platform setup)
./scripts/macos.sh        # macOS 패키지 설치
./scripts/linux.sh        # Linux/WSL 패키지 설치
```

## Structure

```
dotfiles/
├── zsh/.zshrc            # Zsh 설정
├── git/.gitconfig        # Git 설정
├── starship/starship.toml # Starship 프롬프트
├── ssh/config            # SSH 설정
├── nvim/                 # Neovim 설정 (lazy.nvim)
├── packages/             # 패키지 리스트 (macos, linux, windows)
└── scripts/
    ├── linux.sh          # Linux/WSL 패키지 설치
    └── macos.sh          # macOS 패키지 설치
```

## Adding New Configs

1. `<app>/` 디렉토리 생성
2. 설정 파일 추가
3. `install.sh`에 `link_file` 추가

```bash
# install.sh 패턴
link_file "$DOTFILES_DIR/<app>/config" "$HOME/.config/<app>/config"
```

## Package Management

- `packages/*.md`: 플랫폼별 패키지 리스트 (Required/Optional)
- 설치: `scripts/macos.sh` 또는 `scripts/linux.sh`
- 싱크 전략: `.project/design.md` 참고

## Development Guidelines

- 설정 최소화: 필요한 것만 추가
- 플랫폼 호환성 고려: macOS/Linux 분기 처리
- 주석으로 설정 의도 설명
- 테스트용 설치는 packages/*.md의 Required에 추가하지 않음

## Commands

- `/prime-context` - Load context (start session)
- `/update-context` - Save context (end session)
- `/focus` - Show/set current focus
- `/commit` - Smart commit

## Git Commits

Do NOT include AI attribution in commits.

## Node Version Management (fnm)

This project uses **fnm** (Fast Node Manager) instead of nvm.

### Migration from nvm to fnm (2026-01)

**Steps taken:**
1. Installed fnm via Homebrew: `brew install fnm`
2. Installed Node.js: `fnm install 22 && fnm default 22`
3. Installed Bun separately: `curl -fsSL https://bun.sh/install | bash`

**Lesson Learned:** When migrating between Node version managers, global npm packages do NOT automatically transfer. You must:
1. Export packages before switching: `npm list -g --depth=0 > ~/global-packages.txt`
2. Install fnm and set up Node
3. Reinstall each global package manually

Key global packages to reinstall:
```bash
npm install -g @anthropic-ai/claude-code @fission-ai/openspec
```

**Note for AI assistants:** When helping users migrate Node version managers, always remember to handle global package migration explicitly. The packages live in the old manager's directory and won't be available after switching.

## Claude Code Setup

Install Claude Code first:
```bash
npm install -g @anthropic-ai/claude-code
```

Plugins:
```bash
/plugin install mindcontext-core@tmsjngx0
/plugin install claude-mem@thedotmack
/plugin install feature-dev@claude-plugins-official
```

NPM packages:
```bash
npm install -g @fission-ai/openspec  # Spec-driven development
```

Bun (fast JS runtime):
```bash
curl -fsSL https://bun.sh/install | bash
```

### StatusLine Configuration

Custom statusLine showing: `hostname ➜ folder git:(branch) ✗`

1. Create `~/.claude/statusline-command.sh`:
```bash
#!/bin/bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
folder=$(basename "$cwd")
hostname=$(hostname -s)

output="${hostname} "
output+=$(printf "\033[1;32m➜\033[0m")
output+=" ${folder}"

if [ -d "${cwd}/.git" ] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        output+=" git:(${branch})"
        if ! git -C "$cwd" --no-optional-locks diff --quiet 2>/dev/null || \
           ! git -C "$cwd" --no-optional-locks diff --cached --quiet 2>/dev/null; then
            output+=$(printf " \033[1;33m✗\033[0m")
        fi
    fi
fi
echo "$output"
```

2. Add to `~/.claude/settings.json`:
```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statusline-command.sh"
  }
}
```

**Alternative statusLine ideas:**
- Minimal: `◉ main` (just git branch)
- SSH-style: `thoma@macbook ~/devops (main±)`
- Time-aware: `14:32 devops git:(main)`
- Fish-style: `❯❯❯ devops (main*)`
