-- lua/plugins/ui.lua
return {
	-- Notifications
	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 3000,
			render = "default",
			stages = "static",
		},
		config = function(_, opts)
			local notify = require("notify")
			notify.setup(opts)
			vim.notify = function(msg, level, o)
				if level == vim.log.levels.ERROR then
					o = o or {}
					o.timeout = 0
				end
				notify(msg, level, o)
			end
		end,
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
