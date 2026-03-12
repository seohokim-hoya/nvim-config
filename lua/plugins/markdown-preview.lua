return {
	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		init = function()
			vim.g.mkdp_echo_preview_url = 1
			vim.g.mkdp_browserfunc = "MkdpOpenWSL"
			vim.cmd([[
	     function! MkdpOpenWSL(url)
	       execute 'silent !wslview ' . shellescape(a:url)
	     endfunction
	   ]])
		end,
		keys = {
			{ "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
		},
	},
}
