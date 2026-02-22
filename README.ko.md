# Neovim 설정 (lazy.nvim + Neovim 0.11+)

개인용 Neovim 설정 저장소입니다. Lua 모듈 구조로 분리되어 있고, 플러그인은 `lazy.nvim`으로 관리하며 버전은 `lazy-lock.json`으로 고정합니다.

- **리더 키**: `,`
- **로컬 리더 키**: `;`
- **테마**: `cyberdream` (투명 배경)
- **플러그인 매니저**: `lazy.nvim`
- **LSP 방식**: Neovim **0.11+** (`vim.lsp.config`, `vim.lsp.enable`)

---

## 개요

구성은 크게 다음과 같습니다.

- `lua/config/*`: 편집기 동작(옵션, 자동명령, 키맵, 클립보드, lazy 부트스트랩)
- `lua/plugins/*`: 기능별 플러그인 스펙
- `lua/utils/*`: 유틸리티 함수

목표:

- lazy 로딩 기반의 빠른 시작
- 실사용 IDE 워크플로우(LSP/포맷/진단/테스트/디버그/Git/세션)
- 락파일 기반 재현성

---

## 요구사항

### 필수

- Neovim **0.11 이상**
- `git`

### 공통 의존성

- `make` (예: `telescope-fzf-native`, LuaSnip jsregexp 빌드)
- `npm` (`markdown-preview.nvim` 빌드)
- 클립보드 백엔드:
  - WSL: `win32yank.exe`
  - Linux Wayland: `wl-copy`, `wl-paste`
  - Linux X11 fallback: `xclip`

### 선택(설정된 플러그인에서 사용)

- `zathura` (vimtex 뷰어)
- `xxd` (hex.nvim)
- `gio trash` (Linux에서 nvim-genghis)

---

## 설치

```bash
# 선택: 기존 설정 백업
mv ~/.config/nvim ~/.config/nvim.bak.$(date +%s) 2>/dev/null || true

# 클론
git clone <REPO_URL> ~/.config/nvim

# 첫 실행 (lazy.nvim 자동 부트스트랩)
nvim
```

실행 후 확인:

- `:Lazy`
- `:Mason`

---

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
    │   ├── latex.lua
    │   ├── lazygit.lua
    │   ├── lsp.lua
    │   ├── markdown-preview.lua
    │   ├── noice.lua
    │   ├── oneliner.lua
    │   ├── telescope.lua
    │   ├── toggleterm.lua
    │   ├── treesitter.lua
    │   └── ui.lua
    └── utils
        ├── debug.lua
        └── keyMapper.lua
```

---

## 주요 모듈

- `init.lua`: 리더 키 설정 + 핵심 모듈 로딩
- `lua/config/options.lua`: 기본 편집 옵션
- `lua/config/autocmds.lua`:
  - markdown/text 자동 줄바꿈
  - `FocusGained` 시 `+` 레지스터를 unnamed(`"`)에 동기화
  - `.sage` 확장자를 `python` 파일타입으로 매핑
- `lua/config/clipboard.lua`: OS/환경별 클립보드 provider 자동 설정
- `lua/config/keybinds.lua`: 전역 키맵
- `lua/config/lazy.lua`: lazy.nvim 부트스트랩 + plugin import
- `lua/plugins/lsp.lua`: Mason/LSP, 진단 표시, conform 포맷터, `:Format`
- `lua/plugins/treesitter.lua`: 파서 설치 + 대용량 파일 가드 + fold/indent 설정
- `lua/utils/keyMapper.lua`: `vim.keymap.set` 래퍼
- `lua/utils/debug.lua`: dump/메모리·extmark 디버깅 유틸

---

## 자주 쓰는 키맵 (일부)

> `<leader>`는 `,`입니다.

| 키 | 동작 |
|---|---|
| `<C-j>`, `<C-k>` | 다음/이전 진단 |
| `<leader>de` | 진단 플로트 |
| `<C-p>` | Neo-tree 포커스 |
| `<leader>fe`, `<leader>fE` | Neo-tree root/cwd 탐색 |
| `<leader>ff`, `<leader>fg` | Telescope 파일/문자열 검색 |
| `<leader>fb`, `<leader>fh` | Telescope 버퍼/도움말 |
| `<leader>xx` | Trouble 진단 패널 |
| `<leader>ghs`, `<leader>ghr`, `<leader>ghp` | hunk stage/reset/preview |
| `<leader>gd`, `<leader>gD` | Diffview 열기/파일 히스토리 |
| `<leader>gg`, `<leader>lg` | Neogit/LazyGit |
| `<leader>tt`, `<leader>tT` | neotest 근처/파일 실행 |
| `<F5>`, `<F10>`, `<F11>`, `<F12>` | DAP continue/step over/into/out |
| `<leader>db`, `<leader>dB` | 브레이크포인트 토글/조건부 |
| `<leader>fo` | 포맷(`:Format`) |
| `<leader>z` | Zen 모드 |
| `<leader>qs`, `<leader>ql`, `<leader>qd` | 세션 복원/마지막/저장 중지 |

---

## 플러그인 하이라이트

### 편집/탐색

- `neo-tree`, `telescope`, `flash.nvim`, `which-key`
- `bufferline`, `winshift`, `aerial`, `nvim-genghis`, `hex.nvim`

### 코딩 생산성

- `nvim-cmp` + `LuaSnip` + `friendly-snippets`
- `neogen`, `refactoring.nvim`, `multicursors.nvim`
- `nvim-surround`, `mini.pairs`, `mini.bracketed`

### IDE 워크플로우

- 진단/문제: `trouble.nvim`
- Git: `gitsigns`, `diffview`, `neogit`, `vim-fugitive`, `lazygit.nvim`
- 테스트: `neotest`
- 디버깅: `nvim-dap`, `nvim-dap-ui`, `nvim-dap-virtual-text`
- 작업/세션: `overseer.nvim`, `persistence.nvim`
- TODO 탐색: `todo-comments.nvim`

### UI

- `cyberdream`, `lualine`, `noice.nvim`, `nvim-notify`
- `zen-mode`, `vimade`, `incline`, `nvim-highlight-colors`

---

## LSP / 언어 지원

설정된 LSP 서버:

`lua_ls`, `pyright`, `ruff`, `clangd`, `cmake`, `marksman`, `jsonls`, `yamlls`, `dockerls`, `docker_compose_language_service`, `ts_ls`, `rust_analyzer`, `taplo`, `bashls`, `tailwindcss`, `typos_lsp`, `texlab`

포맷터(`conform.nvim`):

- Lua: `stylua`
- Python: `isort`, `black`
- JS/TS/YAML/JSON: `prettierd`, `prettier`
- Rust: `rustfmt`
- Shell: `shfmt`

Treesitter 파서:

`lua`, `vim`, `vimdoc`, `query`, `javascript`, `typescript`, `jsx`, `tsx`, `css`, `html`, `markdown`, `markdown_inline`, `latex`

추가 사항:

- `.sage` 파일은 Python으로 처리
- 저장 시 자동 포맷 활성화 (`timeout_ms = 2000`, LSP fallback)
- 전역 virtual_text는 꺼두고, 현재 줄 진단만 extmark로 표시

---

## 클립보드 동작

`lua/config/clipboard.lua`에서 환경을 자동 감지합니다.

1. WSL → `win32yank.exe`
2. Linux Wayland → `wl-copy` / `wl-paste`
3. Linux X11 fallback → `xclip`

그 뒤 `vim.opt.clipboard = "unnamedplus"`를 적용합니다.

또한 `FocusGained` 자동명령으로 `+` 레지스터를 unnamed(`"`) 레지스터에 동기화합니다.

현재 provider 확인:

```vim
:lua print((vim.g.clipboard and vim.g.clipboard.name) or "clipboard provider not detected")
```

---

## 유지보수 팁

1. 플러그인 업데이트 후 `lazy-lock.json` 함께 커밋
2. 정기 업데이트:
   - `:Lazy sync`
   - `:MasonUpdate`
   - `:TSUpdate`
   - `:checkhealth`
3. 키맵 충돌 확인 (`<leader>du`는 기본 키맵과 DAP UI 토글에 모두 사용됨)
4. 외부 바이너리 PATH 점검 (`win32yank`, `wl-copy`, `xclip`, `npm`, `make` 등)
5. LSP 설정 호환을 위해 Neovim 0.11+ 유지

---

## 라이선스

MIT (`LICENSE`)
