# Dotfiles - Project Design

## Vision

여러 머신(macOS, Linux, WSL)에서 일관된 개발 환경을 유지하고, 새 머신 설정 시간을 최소화.

## Current State

- **Configs**: zsh, git, starship, ssh, nvim
- **Install**: 단일 install.sh로 symlink + 패키지 설치
- **Platforms**: macOS, Linux, WSL 지원

## Roadmap

### Near-term
- [ ] VS Code 설정 추가 (settings.json, keybindings.json)
- [ ] tmux/zellij 설정 추가
- [ ] 기존 머신에서 설정 추출 스크립트

### Future
- [ ] 백업/복원 자동화
- [ ] 머신별 설정 분리 (work vs personal)
- [ ] Secret 관리 (1Password CLI 연동)

## Design Decisions

### Symlink 방식 선택
- 이유: 설정 변경 즉시 반영, 단일 소스 관리
- 대안: stow (의존성 추가 필요)

### 단일 install.sh
- 이유: 간단함, 추가 도구 불필요
- 개선 가능: 모듈별 개별 설치 옵션

## Package Sync Strategy (TODO)

현재: `packages/*.md` (리스트) + `scripts/*.sh` (설치) 분리됨 → 싱크 안 맞을 위험

### Option 1: Single Source - 데이터 파일
```
packages/
├── macos.yaml      # source of truth
├── linux.yaml
└── windows.yaml
```
- 스크립트가 YAML 파싱해서 설치
- 장점: 한 곳만 관리
- 단점: YAML 파서 필요 (yq)

### Option 2: Single Source - Markdown 파싱
```
packages/macos.md   # Required 섹션의 코드블록 파싱
```
- `grep -A100 "## Required" | sed -n '/```/,/```/p'`
- 장점: 문서와 데이터 통합
- 단점: 파싱 fragile

### Option 3: 생성 방향 역전
```
packages/
├── required.txt    # 간단한 패키지 리스트 (source)
└── macos.md        # 생성됨 (scan 결과 + required.txt)
```
- `scan-packages.sh`가 현재 상태 + required.txt 비교해서 md 생성
- 장점: 데이터는 단순, 문서는 풍부
- 단점: 생성 스크립트 필요

### Option 4: Brewfile 활용 (macOS only)
```
brew bundle dump    # 현재 상태 → Brewfile
brew bundle         # Brewfile → 설치
```
- 장점: 네이티브, 검증됨
- 단점: macOS 전용, Linux/Windows는 별도

### 권장: Option 3 + 4 혼합
- macOS: Brewfile 사용 (`brew bundle`)
- Linux: `packages/linux-required.txt` + apt
- Windows: `packages/windows-required.txt` + winget
- `scan-packages.sh`: 현재 상태 → *.md 업데이트 (문서용)
