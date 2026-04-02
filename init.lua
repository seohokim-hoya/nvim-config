-- Undo 파일 저장 활성화
vim.opt.undofile = true
-- (선택) 최대 저장 횟수 늘리기 (기본값 1000)
vim.opt.undolevels = 10000

local g = vim.g

g.mapleader = ","
g.maplocalleader = ";"

require("config.autocmds")
require("config.clipboard")
require("config.options")
require("config.keybinds")
require("config.lazy")
