-- lua/plugins/ui.lua
return {
	-- Better messages/cmdline/popup UI
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
			},
		},
		keys = {
			{ "<leader>sn", "", desc = "+noice" },
			{
				"<S-Enter>",
				function()
					require("noice").redirect(vim.fn.getcmdline())
				end,
				mode = "c",
				desc = "Redirect Cmdline",
			},
			{
				"<leader>snl",
				function()
					require("noice").cmd("last")
				end,
				desc = "Noice Last Message",
			},
			{
				"<leader>snh",
				function()
					require("noice").cmd("history")
				end,
				desc = "Noice History",
			},
			{
				"<leader>sna",
				function()
					require("noice").cmd("all")
				end,
				desc = "Noice All",
			},
			{
				"<leader>snd",
				function()
					require("noice").cmd("dismiss")
				end,
				desc = "Dismiss All",
			},
			{
				"<leader>snt",
				function()
					require("noice").cmd("pick")
				end,
				desc = "Noice Picker",
			},

			-- 스크롤 키가 거슬리면 mode를 {"n","s"}로 줄여도 됨
			{
				"<c-f>",
				function()
					if not require("noice.lsp").scroll(4) then
						return "<c-f>"
					end
				end,
				silent = true,
				expr = true,
				mode = { "i", "n", "s" },
				desc = "Scroll Forward",
			},
			{
				"<c-b>",
				function()
					if not require("noice.lsp").scroll(-4) then
						return "<c-b>"
					end
				end,
				silent = true,
				expr = true,
				mode = { "i", "n", "s" },
				desc = "Scroll Backward",
			},
		},
		config = function(_, opts)
			if vim.o.filetype == "lazy" then
				vim.cmd([[messages clear]])
			end
			require("noice").setup(opts)
		end,
	},

	-- Notifications
	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 1000,
			render = "compact",
			stages = "static",
		},
	},

	-- Buffer line (중복 config 제거)
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				mode = "buffers",
				separator_style = "thin",
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		},
	},

	-- Window title (optional)
	{
		"b0o/incline.nvim",
		event = "BufReadPre",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			window = { margin = { vertical = 0, horizontal = 1 } },
			hide = { cursorline = true },
			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				if vim.bo[props.buf].modified then
					filename = "[+] " .. filename
				end
				local icon, color = require("nvim-web-devicons").get_icon_color(filename)
				return { { icon, guifg = color }, { " " }, { filename } }
			end,
		},
	},

	-- Focus mode
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
		opts = {
			plugins = {
				gitsigns = true,
				tmux = true,
				kitty = { enabled = false, font = "+2" },
			},
		},
	},

	-- transparent
	-- {
	-- 	"xiyaowong/transparent.nvim",
	-- 	opts = {
	-- 		groups = {
	-- 			"Normal",
	-- 			"NormalNC",
	-- 			"EndOfBuffer",
	-- 			"SignColumn",
	-- 		},
	-- 		extra_groups = { "NormalFloat" },
	-- 	},
	-- },

	-- vimade
	{
		"tadaa/vimade",
		event = "VeryLazy",
		opts = {
			recipe = { "minimalist", { animate = false } },
			ncmode = "windows", -- 포커스 창 vs 나머지 창 구분이 가장 직관적
			fadelevel = 0.7, -- cyberdream 투명 위에서 0.4는 너무 죽을 수 있음
			basebg = "", -- terminal 배경 그대로 기준
			enablefocusfading = false,
			checkinterval = 1000,
			usecursorhold = false,
			nohlcheck = true,
			blocklist = {
				default = {
					buf_opts = { buftype = { "prompt" } },
					win_config = { relative = true }, -- float은 보통 디밍 안 하는 게 보기 좋음
				},
			},
		},
	},
}
