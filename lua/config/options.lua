local opt = vim.opt

opt.number = true
opt.cursorline = true
opt.relativenumber = true
opt.shiftwidth = 4
opt.scrolloff = 10
opt.laststatus = 3
opt.title = true

opt.expandtab = true
opt.tabstop = 4
opt.smarttab = true
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true

opt.ignorecase = true
opt.hlsearch = true

opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "cursor"

opt.path:append({ "**" })

opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200

opt.inccommand = "split"

opt.wrap = false

opt.mouse = "a"
