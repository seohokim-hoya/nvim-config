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
			vim.g.mkdp_browserfunc = "MkdpOpenWSLChromeIncognito"

			vim.cmd([[
      function! MkdpOpenWSLChromeIncognito(url)
        call system('powershell.exe -NoProfile -Command "Start-Process chrome.exe -ArgumentList ''--new-window'',''--incognito'',''' . a:url . '''"')
      endfunction
    ]])
		end,
		keys = {
			{ "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
		},
	},
}
