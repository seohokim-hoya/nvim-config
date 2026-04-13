# Neovim Config (lazy.nvim + Neovim 0.11+)

---

Personal Neovim configuration with modular Lua files, lazy-loaded plugins, and pinned plugin versions.

- **Leader**: `,`
- **Local leader**: `;`
- **Colorscheme**: `cyberdream` (transparent)
- **Plugin manager**: `lazy.nvim`
- **LSP style**: Neovim **0.11+** (`vim.lsp.config`, `vim.lsp.enable`)

---

## Overview

This config is split into:

- `lua/config/*` for editor behavior (options, autocmds, keybinds, clipboard, lazy bootstrap)
- `lua/plugins/*` for plugin specs by domain
- `lua/utils/*` for helpers

Goals:

- fast startup via lazy loading
- practical IDE workflow (LSP, formatting, diagnostics, tests, debug, git, sessions)
- reproducible plugin versions via `lazy-lock.json`

---

## Requirements

### Required

- Neovim **0.11+**
- `git`

### Common dependencies

- `make` (e.g. `telescope-fzf-native`, LuaSnip jsregexp build)
- `npm` (`markdown-preview.nvim` build)
- Clipboard backend:
  - WSL: `win32yank.exe`
  - Linux Wayland: `wl-copy` + `wl-paste`
  - Linux X11 fallback: `xclip`

### Optional tools used by configured plugins

- `zathura` (vimtex viewer)
- `xxd` (hex.nvim)
- `gio trash` (nvim-genghis on Linux)

---

## Installation

```bash
# Optional backup
mv ~/.config/nvim ~/.config/nvim.bak.$(date +%s) 2>/dev/null || true

# Clone
git clone <REPO_URL> ~/.config/nvim

# First run (lazy.nvim bootstraps automatically)
nvim
```

Then check:

- `:Lazy`
- `:Mason`

---

## Structure

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

## Key Modules

- `init.lua`: leader/localleader + loads all core modules
- `lua/config/options.lua`: base editor options
- `lua/config/autocmds.lua`:
  - wraps markdown/text automatically
  - syncs `+` register into unnamed register on `FocusGained`
  - maps `.sage` extension to `python` filetype
- `lua/config/clipboard.lua`: OS-aware clipboard provider setup
- `lua/config/keybinds.lua`: global keymaps
- `lua/config/lazy.lua`: lazy.nvim bootstrap + plugin import
- `lua/plugins/lsp.lua`: Mason/LSP setup, diagnostics style, conform formatters, `:Format`
- `lua/plugins/treesitter.lua`: parser install + big-file guard + fold/indent integration
- `lua/utils/keyMapper.lua`: flexible wrapper around `vim.keymap.set`
- `lua/utils/debug.lua`: dump and memory/extmark debug helpers

---

## Key Mappings (selected)

> `<leader>` is `,`

| Key                                         | Action                           |
| ------------------------------------------- | -------------------------------- |
| `<C-j>`, `<C-k>`                            | next/previous diagnostic         |
| `<leader>de`                                | diagnostic float                 |
| `<C-p>`                                     | focus Neo-tree                   |
| `<leader>fe`, `<leader>fE`                  | Neo-tree root/cwd explorer       |
| `<leader>ff`, `<leader>fg`                  | Telescope find files/live grep   |
| `<leader>fb`, `<leader>fh`                  | Telescope buffers/help tags      |
| `<leader>xx`                                | Trouble diagnostics              |
| `<leader>ghs`, `<leader>ghr`, `<leader>ghp` | stage/reset/preview hunk         |
| `<leader>gd`, `<leader>gD`                  | Diffview open/file history       |
| `<leader>gg`, `<leader>lg`                  | Neogit/LazyGit                   |
| `<leader>tt`, `<leader>tT`                  | neotest nearest/file             |
| `<F5>`, `<F10>`, `<F11>`, `<F12>`           | DAP continue/step over/into/out  |
| `<leader>db`, `<leader>dB`                  | toggle/conditional breakpoint    |
| `<leader>fo`                                | format (`:Format`)               |
| `<leader>z`                                 | Zen mode                         |
| `<leader>qs`, `<leader>ql`, `<leader>qd`    | restore session/last/stop saving |

---

## Plugin Highlights

### Editing & navigation

- `neo-tree`, `telescope`, `flash.nvim`, `which-key`
- `bufferline`, `winshift`, `aerial`, `nvim-genghis`, `hex.nvim`

### Coding productivity

- `nvim-cmp` + `LuaSnip` + `friendly-snippets`
- `neogen`, `refactoring.nvim`, `multicursors.nvim`
- `nvim-surround`, `mini.pairs`, `mini.bracketed`

### IDE workflow

- diagnostics/issues: `trouble.nvim`
- git: `gitsigns`, `diffview`, `neogit`, `vim-fugitive`, `lazygit.nvim`
- testing: `neotest`
- debugging: `nvim-dap`, `nvim-dap-ui`, `nvim-dap-virtual-text`
- task/session: `overseer.nvim`, `persistence.nvim`
- TODO navigation: `todo-comments.nvim`

### UI

- `cyberdream`, `lualine`, `noice.nvim`, `nvim-notify`
- `zen-mode`, `vimade`, `incline`, `nvim-highlight-colors`

---

## Language Support / LSP

Configured LSP servers:

`lua_ls`, `pyright`, `ruff`, `clangd`, `cmake`, `marksman`, `jsonls`, `yamlls`, `dockerls`, `docker_compose_language_service`, `ts_ls`, `rust_analyzer`, `taplo`, `bashls`, `tailwindcss`, `typos_lsp`, `texlab`

Configured formatters (`conform.nvim`):

- Lua: `stylua`
- Python: `isort`, `black`
- JS/TS/JSX/TSX: local `eslint_d` (when available) -> `prettierd` -> `prettier`
- JSON/YAML/Markdown: `prettierd`, `prettier`
- Rust: `rustfmt`
- Shell: `shfmt`

Treesitter parsers installed:

`lua`, `vim`, `vimdoc`, `query`, `javascript`, `typescript`, `jsx`, `tsx`, `css`, `html`, `markdown`, `markdown_inline`, `latex`

Notes:

- `.sage` files are treated as Python
- save-time formatting is enabled
- JS/TS/JSX/TSX wait for synchronous external formatting on save (`timeout_ms = 3000`, no LSP fallback)
- web formatter errors or missing formatters are surfaced via notifications
- diagnostics virtual text is disabled globally; current-line diagnostics are shown via extmark on `CursorHold`

---

## Clipboard Behavior

`lua/config/clipboard.lua` auto-detects environment:

1. WSL → `win32yank.exe`
2. Linux Wayland → `wl-copy`/`wl-paste`
3. Linux X11 fallback → `xclip`

Then `vim.opt.clipboard = "unnamedplus"` is applied.

Additionally, `FocusGained` syncs `+` register into unnamed register (`"`).

Check active provider inside Neovim:

```vim
:lua print((vim.g.clipboard and vim.g.clipboard.name) or "clipboard provider not detected")
```

---

## Maintenance Tips

1. Keep `lazy-lock.json` committed after plugin updates.
2. Run updates regularly:
   - `:Lazy sync`
   - `:MasonUpdate`
   - `:TSUpdate`
   - `:checkhealth`
3. Watch mapping overlap (`<leader>du` appears in both base keybinds and DAP UI mapping).
4. Ensure external binaries exist in `PATH` (`win32yank`, `wl-copy`, `xclip`, `npm`, `make`, etc.).
5. Stay on Neovim 0.11+ for current LSP configuration compatibility.

---

## License

MIT (`LICENSE`)
