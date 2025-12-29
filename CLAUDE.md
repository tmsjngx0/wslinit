# Dotfiles

개인 개발 환경 설정 통합 관리. macOS, Linux, WSL에서 일관된 개발 환경 유지.

## Quick Reference

```bash
./install.sh              # 전체 설치 (symlinks + platform setup)
```

## Structure

```
dotfiles/
├── zsh/.zshrc            # Zsh 설정
├── git/.gitconfig        # Git 설정
├── starship/starship.toml # Starship 프롬프트
├── ssh/config            # SSH 설정
├── nvim/                 # Neovim 설정 (lazy.nvim)
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

## Development Guidelines

- 설정 최소화: 필요한 것만 추가
- 플랫폼 호환성 고려: macOS/Linux 분기 처리
- 주석으로 설정 의도 설명
