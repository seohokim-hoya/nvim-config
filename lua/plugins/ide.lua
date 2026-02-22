return {
	---------------------------------------------------------------------------
	-- Problems / Diagnostics panel
	---------------------------------------------------------------------------
	{
		"folke/trouble.nvim",
		cmd = { "Trouble" },
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble: Diagnostics" },
			{ "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble: Quickfix" },
			{ "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble: Location List" },
			{ "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>", desc = "Trouble: References" },
		},
		opts = {
			focus = true,
			follow = true,
			auto_preview = false,
		},
	},

	---------------------------------------------------------------------------
	-- Git (signs + diff UI + magit-like UI)
	---------------------------------------------------------------------------
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			current_line_blame = false,
		},
		keys = {
			{
				"]h",
				function()
					require("gitsigns").next_hunk()
				end,
				desc = "Git: Next Hunk",
			},
			{
				"[h",
				function()
					require("gitsigns").prev_hunk()
				end,
				desc = "Git: Prev Hunk",
			},
			{
				"<leader>ghs",
				function()
					require("gitsigns").stage_hunk()
				end,
				desc = "Git: Stage Hunk",
			},
			{
				"<leader>ghr",
				function()
					require("gitsigns").reset_hunk()
				end,
				desc = "Git: Reset Hunk",
			},
			{
				"<leader>ghp",
				function()
					require("gitsigns").preview_hunk()
				end,
				desc = "Git: Preview Hunk",
			},
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: Open" },
			{ "<leader>gD", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: File History" },
		},
	},
	{
		"NeogitOrg/neogit",
		cmd = { "Neogit" },
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
		},
		opts = {
			kind = "tab",
		},
	},

	---------------------------------------------------------------------------
	-- Testing (Jest; 필요하면 adapter 추가)
	---------------------------------------------------------------------------
	{
		"nvim-neotest/neotest",
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact", "lua", "python", "rust", "php" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-jest",
			-- 필요하면 추가:
			-- "nvim-neotest/neotest-python",
			-- "rouge8/neotest-rust",
			-- PHP는 프로젝트/프레임워크에 따라 선택이 갈려서 일단 비워둠
		},
		keys = {
			{
				"<leader>tt",
				function()
					require("neotest").run.run()
				end,
				desc = "Test: Run Nearest",
			},
			{
				"<leader>tT",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Test: Run File",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Test: Summary",
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open({ enter = true })
				end,
				desc = "Test: Output",
			},
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-jest")({
						jestCommand = "npm test --",
						env = { CI = true },
					}),
				},
			})
		end,
	},

	---------------------------------------------------------------------------
	-- Debugging (DAP)
	---------------------------------------------------------------------------
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "DAP: Continue",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "DAP: Step Over",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "DAP: Step Into",
			},
			{
				"<F12>",
				function()
					require("dap").step_out()
				end,
				desc = "DAP: Step Out",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "DAP: Breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "DAP: Conditional BP",
			},
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap" },
		keys = {
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "DAP UI: Toggle",
			},
		},
		opts = {},
		config = function(_, opts)
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
		opts = {},
	},

	---------------------------------------------------------------------------
	-- Task runner (build/test/devserver like IDE)
	---------------------------------------------------------------------------
	{
		"stevearc/overseer.nvim",
		cmd = { "OverseerRun", "OverseerToggle" },
		keys = {
			{ "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer: Run Task" },
			{ "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Overseer: Toggle" },
		},
		opts = {},
	},

	---------------------------------------------------------------------------
	-- Sessions
	---------------------------------------------------------------------------
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Session: Restore",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Session: Restore Last",
			},
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Session: Stop Saving",
			},
		},
		opts = {},
	},

	---------------------------------------------------------------------------
	-- TODO/FIXME management
	---------------------------------------------------------------------------
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo: Telescope" },
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Todo: Next",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Todo: Prev",
			},
		},
		opts = {},
	},
}
