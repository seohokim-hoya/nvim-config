vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text" },
	callback = function()
		vim.opt_local.wrap = true
	end,
})

vim.api.nvim_create_autocmd("FocusGained", {
	group = vim.api.nvim_create_augroup("ClipboardSync", { clear = true }),
	callback = function()
		-- + 레지스터 내용을 unnamed에도 반영(원하면)
		vim.fn.setreg('"', vim.fn.getreg("+"))
	end,
})

vim.filetype.add({
	extension = {
		sage = "python",
	},
})
