return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		vim.g.vimtex_view_method = "sioyek"
		vim.g.vimtex_view_sioyek_exe = "sioyek.exe"
		-- Use the Windows executable explicitly so Sioyek does not depend on PATH resolution for `wsl`.
		vim.g.vimtex_callback_progpath = "wsl nvim"
	end,
}
