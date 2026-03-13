return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			shade_terminal = false,
			size = function()
				return math.floor(vim.o.columns * 0.97)
			end,
			open_mapping = [[<S-A-H>]],
			direction = "float",
			start_in_insert = true,
			persist_mode = true,
			close_on_exit = true,
			float_opts = {
				border = "rounded",
			},
		})
	end,
}
