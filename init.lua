local g = vim.g

g.mapleader = ","
g.maplocalleader = ";"

require("config.autocmds")
require("config.clipboard")
require("config.options")
require("config.keybinds")
require("config.lazy")
