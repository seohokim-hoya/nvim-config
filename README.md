# Neovim 설정 (Lazy.nvim 기반)

이 저장소는 개인용 Neovim 설정입니다. `init.lua`에서 `lua/config/*`와 `lua/plugins/*`를 불러오며, 플러그인 관리는 **lazy.nvim**을 사용합니다.

## 개요

- 리더 키: `,`
- 로컬 리더 키: `;`
- 기본 UI: 상대 줄번호, 커서라인, 전역 상태줄(`laststatus=3`)
- 테마: `cyberdream`
- 클립보드: WSL + `win32yank.exe` 연동
- LSP 구성: Neovim **0.11+** API(`vim.lsp.config`, `vim.lsp.enable`) 기준

## 폴더 구조

```text
.
├── init.lua
├── lazy-lock.json
└── lua
    ├── config
    │   ├── autocmds.lua
    │   ├── clipboard.lua
    │   ├── keybinds.lua
    │   ├── lazy.lua
    │   └── options.lua
    ├── plugins
    │   ├── coding.lua
    │   ├── colors.lua
    │   ├── editor.lua
    │   ├── ide.lua
    │   ├── lsp.lua
    │   ├── oneliner.lua
    │   ├── telescope.lua
    │   ├── toggleterm.lua
    │   ├── treesitter.lua
    │   └── ui.lua
    └── utils
        ├── debug.lua
        └── keyMapper.lua
```

## 주요 구성

### 1) 편집/탐색

- 파일 트리: `neo-tree`
- 빠른 이동: `flash.nvim`
- 키 힌트: `which-key`
- 버퍼/탭 UX: `bufferline`
- 검색: `telescope`(+ `telescope-fzf-native`)

### 2) 코딩 보조

- 자동완성: `nvim-cmp` + `LuaSnip` + `friendly-snippets`
- 리팩토링: `refactoring.nvim`
- 주석/문서 템플릿: `neogen`
- 괄호/서라운드: `mini.pairs`, `nvim-surround`
- 멀티커서: `multicursors.nvim`

### 3) LSP/포매터

- 패키지 관리: `mason.nvim`, `mason-lspconfig.nvim`
- LSP: `nvim-lspconfig`
- 포맷터: `conform.nvim`
- 기본 설치 서버(요약): Lua/Python/C/CMake/TS/JS/Rust/YAML/JSON/TOML/Bash/Tailwind 등

### 4) IDE 기능

- 진단 패널: `trouble.nvim`
- Git: `gitsigns`, `diffview`, `neogit`, `vim-fugitive`
- 테스트: `neotest`(Jest/Python/Rust 어댑터 포함)
- 디버깅: `nvim-dap`, `nvim-dap-ui`, `nvim-dap-virtual-text`
- 작업 실행: `overseer.nvim`
- 세션 복원: `persistence.nvim`

### 5) UI/시각 효과

- 메시지/팝업: `noice.nvim`, `nvim-notify`
- 상태줄: `lualine`
- 포커스 모드: `zen-mode`
- 비활성 창 디밍: `vimade`
- 컬러 코드 하이라이트: `nvim-highlight-colors`

## 자주 쓰는 키맵 (일부)

- 진단 이동: `<C-j>`, `<C-k>`
- 진단 플로트: `<leader>de`
- 파일 트리 포커스: `<C-p>`
- Telescope: `<leader>ff`(파일), `<leader>fg`(문자열)
- Trouble 진단: `<leader>xx`
- 테스트 실행: `<leader>tt`(근처), `<leader>tT`(파일)
- DAP: `<F5>` 실행, `<F10>/<F11>/<F12>` 스텝

> 참고: 키맵은 개인 워크플로우 기준이라 환경에 따라 조정이 필요할 수 있습니다.

## 설치/적용

1. 이 폴더를 Neovim 설정 경로로 배치
   - Linux/macOS: `~/.config/nvim`
2. Neovim 실행 시 `lazy.nvim`이 자동 부트스트랩됨
3. `:Mason`에서 LSP/툴 설치 상태 확인

## 환경별 가이드

현재 클립보드 설정은 `lua/config/clipboard.lua`에서 **환경을 자동 감지해 분기**합니다.

- **WSL2**: `win32yank.exe` 사용
- **Linux Wayland**: `wl-copy`/`wl-paste` 사용
- **Linux X11 (fallback)**: `xclip` 사용

즉, WSL2/Linux(X11/Wayland)마다 설정 파일을 수동 교체하지 않아도 됩니다.

체크 포인트:
- `vim.opt.clipboard = "unnamedplus"` 유지
- 각 환경에서 필요한 바이너리(`win32yank.exe`, `wl-clipboard`, `xclip`)가 PATH에 있어야 시스템 클립보드 연동 가능

간단 검증 팁(Neovim 내부):

```vim
:lua print((vim.g.clipboard and vim.g.clipboard.name) or "clipboard provider not detected")
```

출력된 `name` 값으로 현재 감지된 클립보드 provider를 바로 확인할 수 있습니다.

## 참고 파일

- `lazy-lock.json`: 플러그인 커밋 고정(재현성)
- `lua/utils/debug.lua`: 디버깅 보조 함수
