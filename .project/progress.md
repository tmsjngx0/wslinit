# Progress

## Current Focus
패키지 관리 전략 설계 완료. 다음: cleanup 스크립트 또는 scan 스크립트 구현.

## Session Log

### 2025-12-28
- nvim 최소 설정 구성 (lazy.nvim 기반)
  - catppuccin 테마
  - telescope (파일 검색)
  - neo-tree (파일 탐색기)
  - gitsigns + diffview (git 연동)
- dotfiles 레포에 nvim/ 추가
- install.sh에 nvim symlink 추가
- MindContext 초기화
- 패키지 관리 체계 구축
  - packages/macos.md, linux.md, windows.md 생성
  - brew 현재 상태 스캔 및 스냅샷
  - Required vs Optional 분류
- 패키지 싱크 전략 설계 (.project/design.md)
  - Option 1-4 비교 (YAML, Markdown 파싱, txt→md 생성, Brewfile)
  - 권장: Brewfile + txt 혼합 방식
- cleanup-check.sh 아이디어 추가
  - 설치됨 vs 필요함 비교
  - 테스트용 앱 정리 리마인더

## Next Steps
- [ ] packages/macos-required.txt 생성 (source of truth)
- [ ] cleanup-check.sh 구현
- [ ] scan-packages.sh 구현
- [ ] gh config (git_protocol: ssh) 추가
