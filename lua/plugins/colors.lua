return {
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,

		opts = {},
		config = function()
			require("cyberdream").setup({
				transparent = true,
				borderless_telescope = false,
				styles = {
					sidebar = "transparent",
					float = "transparent",
				},
				extensions = {
					telescope = true,
				},
			})
			vim.cmd("colorscheme cyberdream")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			theme = "cyberdream",
		},
	},
}
