return {
	"iamcco/markdown-preview.nvim",
	ft = { "markdown" },
	cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
	build = "cd app && npm install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	keys = {
		{ "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
	},
}
