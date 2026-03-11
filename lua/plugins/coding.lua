-- lua/plugins/coding.lua
return {
	-- Doc/annotation generator
	{
		"danymat/neogen",
		keys = {
			{
				"<leader>cc",
				function()
					require("neogen").generate({})
				end,
				desc = "Neogen Comment",
			},
		},
		opts = { snippet_engine = "luasnip" },
	},

	-- Refactoring (treesitter-based)
	{
		"ThePrimeagen/refactoring.nvim",
		keys = {
			{
				"<leader>rn",
				function()
					require("refactoring").select_refactor()
				end,
				mode = "v",
				desc = "Refactor (visual)",
			},
		},
		opts = {},
	},

	-- Bracket motions: [q ]q [b ]b [n ]n etc
	{
		"echasnovski/mini.bracketed",
		event = "BufReadPost",
		opts = {
			file = { suffix = "" },
			window = { suffix = "" },
			quickfix = { suffix = "" },
			yank = { suffix = "" },
			treesitter = { suffix = "n" },
		},
		config = function(_, opts)
			require("mini.bracketed").setup(opts)
		end,
	},

	-- Outline
	{
		"stevearc/aerial.nvim",
		keys = { { "<leader>so", "<cmd>AerialToggle!<cr>", desc = "Aerial Outline" } },
		cmd = { "AerialToggle", "AerialOpen", "AerialClose" },
		opts = {
			layout = { default_direction = "right" },
			backends = { "lsp", "treesitter" },
		},
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			-- Snippet engine (단일 정의)
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
				dependencies = { "rafamadriz/friendly-snippets" },
				config = function()
					local ls = require("luasnip")
					ls.setup()
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_vscode").lazy_load({
						paths = { vim.fn.expand("~/.config/nvim/snippets") },
					})

					-- 키맵은 취향인데, 최소한으로 정리 추천
					vim.keymap.set({ "i", "s" }, "<C-j>", function()
						if ls.jumpable(1) then
							ls.jump(1)
						end
					end, { silent = true })
					vim.keymap.set({ "i", "s" }, "<C-k>", function()
						if ls.jumpable(-1) then
							ls.jump(-1)
						end
					end, { silent = true })
					vim.keymap.set({ "i", "s" }, "<C-l>", function()
						if ls.choice_active() then
							ls.change_choice(1)
						end
					end, { silent = true })
				end,
			},

			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
		},
		config = function()
			vim.opt.completeopt = "menu,menuone,noselect"

			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				preselect = cmp.PreselectMode.None,
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				completion = {
					completeopt = "menu,menuone,noinsert,noselect",
				},
				mapping = {
					["<Tab>"] = cmp.mapping(function(fallback)
						local col = vim.fn.col(".") - 1
						if cmp.visible() then
							cmp.select_next_item()
						elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
							fallback()
						else
							cmp.complete()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip", max_item_count = 5 },
					{ name = "path", max_item_count = 5 },
					-- { name = "buffer", max_item_count = 5 },
				}),
			})
		end,
	},

	-- Surround editing
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		opts = {},
	},

	-- Auto pairs
	{
		"echasnovski/mini.pairs",
		event = "InsertEnter",
		opts = {},
		config = function(_, opts)
			require("mini.pairs").setup(opts)
		end,
	},
}
