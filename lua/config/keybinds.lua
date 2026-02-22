local mapKey = require("utils.keyMapper").mapKey
local opts = { noremap = true, silent = true }

-- Diagnostics
mapKey("<C-j>", function()
	vim.diagnostic.jump({ count = 1 })
end, opts)
mapKey("<C-k>", function()
	vim.diagnostic.jump({ count = -1 })
end, opts)
mapKey("<leader>de", function()
	vim.diagnostic.open_float()
end, opts)

mapKey("<C-p>", "<cmd>Neotree focus<cr>")

mapKey("<S-A-h>", "<cmd>FloatermToggle<cr>", "n")
mapKey("<S-A-n>", "<cmd>FloatermNew<cr>", "n")
mapKey("<S-A-h>", "<C-\\><C-n><cmd>FloatermToggle<cr>", "t")
mapKey("<S-A-n>", "<C-\\><C-n><cmd>FloatermNew<cr>", "t")
mapKey("<S-A-j>", "<C-\\><C-n><cmd>FloatermNext<cr>", "t")
mapKey("<S-A-p>", "<C-\\><C-n><cmd>FloatermNew python3<cr>", "t")

-- mapKey("<C-q>", "@q")

mapKey("<S-A-l>", "<cmd>SimpleNoteList<CR>")
mapKey("<S-A-c>", "<cmd>SimpleNoteCreate<CR>")

mapKey("<tab>", "<cmd>BufferLineCycleNext<CR>", "n")
mapKey("<s-tab>", "<cmd>BufferLineCyclePrev<CR>", "n")

mapKey("<C-W>m", "<cmd>WinShift<CR>")

mapKey("<leader>mp", "<cmd>MarkdownPreview<CR>", "n")
mapKey("<leader>mh", "<cmd>MDHeaders<CR>", "n")
mapKey("<leader>mc", "<cmd>MDHeadersCurrent<CR>", "n")

mapKey("<leader>du", "<cmd>w !dos2unix %<CR><cmd>e!<CR>", "n")

mapKey("<", "<gv", "v")
mapKey(">", ">gv", "v")
