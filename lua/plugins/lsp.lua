local keyMapper = require("utils.keyMapper").mapKey

local servers = {
	-- [Lua]
	"lua_ls",
	-- [Python]
	"pyright",
	"ruff",
	-- [C lang]
	"clangd",
	"cmake",
	-- [Markdown]
	"marksman",
	-- [JSON]
	"jsonls",
	-- [YAML]
	"yamlls",
	-- [Docker]
	"dockerls",
	"docker_compose_language_service",
	-- [ty/js]
	"ts_ls",
	-- [Rust]
	"rust_analyzer",
	-- [TOML]
	"taplo",
	-- [bash]
	"bashls",
	-- [TailwindCSS]
	"tailwindcss",
	-- [Check Typos]
	"typos_lsp",
}

return {
	-- tools
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
				"black",
				"isort",
				"prettierd",
				"prettier",
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		-- mason-lspconfig README에서도 mason.nvim + nvim-lspconfig가 먼저 runtimepath에 있어야 한다고 함
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			local mlsp = require("mason-lspconfig")

			-- v2+ (Neovim 0.11+ 기준): automatic_enable
			local ok = pcall(mlsp.setup, {
				ensure_installed = servers,
				-- 여기서는 우리가 직접 vim.lsp.enable()로 켤 거라 자동 enable은 끔
				automatic_enable = false,
			})

			if not ok then
				-- 구버전 호환 (automatic_installation 옵션 쓰던 시절)
				mlsp.setup({
					ensure_installed = servers,
					automatic_installation = true,
				})
			end
		end,
	},

	-- lsp servers
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Autocompletion
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			-- Snippets
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			-- Neovim 0.11+ API 확인 (README 기준)
			if not (vim.lsp and vim.lsp.config and vim.lsp.enable) then
				vim.notify(
					"이 설정은 Neovim 0.11+ (vim.lsp.config/vim.lsp.enable) 기준입니다.",
					vim.log.levels.ERROR
				)
				return
			end

			local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = ok_cmp and cmp_nvim_lsp.default_capabilities()
				or vim.lsp.protocol.make_client_capabilities()

			-- 모든 서버에 공통 capabilities 적용 (Neovim LSP config merge의 '*' 규칙 활용)
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			local server_configs = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = { library = vim.api.nvim_get_runtime_file("", true) },
							telemetry = { enable = false },
						},
					},
				},
				pylsp = {
					settings = {
						pylsp = {
							plugins = {
								pycodestyle = { enabled = false },
								pyflakes = { enabled = false },
								mccabe = { enabled = false },
								flake8 = { enabled = true },
							},
						},
					},
				},
				yamlls = {
					settings = {
						yaml = {
							schemaStore = { enable = true },
							format = { enable = true },
							validate = true,
						},
					},
				},
				ts_ls = {
					settings = {
						typescript = {
							format = {
								indentSize = 2,
							},
							inlayHints = {
								includeInlayParameterNameHints = "all",
							},
						},
						javascript = {
							format = {
								indentSize = 2,
								semicolons = "remove",
							},
							inlayHints = {
								includeInlayParameterNameHints = "all",
							},
						},
						completions = {
							completeFunctionCalls = true,
						},
					},
					on_attach = function(client)
						-- (원래 코드 유지) 필요하면 여기서 커스텀 키맵 추가 가능
						client.server_capabilities.documentFormattingProvider = false
					end,
				},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
							},
							checkOnSave = {
								command = "clippy",
							},
							procMacro = {
								enable = true,
							},
							inlayHints = {
								bindingModeHints = { enable = true },
								chainingHints = { enable = true },
								closingBraceHints = { enable = true },
								lifetimeElisionHints = {
									enable = "skip_trivial",
								},
								typeHints = { enable = true },
							},
						},
					},
				},
				tailwindcss = {
					settings = {
						tailwindCSS = {
							classAttributes = {
								"class",
								"className",
								"ngClass",
								"class:list",
							},
						},
					},
				},
			}

			-- 서버별 설정 적용
			for name, cfg in pairs(server_configs) do
				vim.lsp.config(name, cfg)
			end

			-- 서버 enable (README 권장 방식)
			local missing = {}
			for _, name in ipairs(servers) do
				if not pcall(vim.lsp.enable, name) then
					missing[#missing + 1] = name
				end
			end
			if #missing > 0 then
				vim.notify(
					("vim.lsp에 등록된 LSP config를 못 찾음: %s"):format(table.concat(missing, ", ")),
					vim.log.levels.WARN
				)
			end

			-- keymaps (기존 방식 유지: global mapping)
			keyMapper("K", vim.lsp.buf.hover)
			keyMapper("<leader>r", vim.lsp.buf.rename)
			keyMapper("<leader>ca", vim.lsp.buf.code_action)

			vim.diagnostic.config({
				underline = true,
				signs = false,
				update_in_insert = false,
				severity_sort = false,
				virtual_text = false,
			})

			local ns = vim.api.nvim_create_namespace("CurlineDiag")
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					vim.api.nvim_create_autocmd("CursorHold", {
						buffer = args.buf,
						callback = function()
							pcall(vim.api.nvim_buf_clear_namespace, args.buf, ns, 0, -1)
							local hi = { "Error", "Warn", "Info", "Hint" }
							local curline = vim.api.nvim_win_get_cursor(0)[1]
							local diagnostics = vim.diagnostic.get(args.buf, { lnum = curline - 1 })
							local virt_texts = { { (" "):rep(4) } }
							for _, diag in ipairs(diagnostics) do
								virt_texts[#virt_texts + 1] = { diag.message, "Diagnostic" .. hi[diag.severity] }
							end
							vim.api.nvim_buf_set_extmark(args.buf, ns, curline - 1, 0, {
								virt_text = virt_texts,
								hl_mode = "combine",
							})
						end,
					})
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
				rust = { "rustfmt" },
				sh = { "shfmt" },
				yaml = { "prettierd", "prettier" },
				json = { "prettierd", "prettier" },
			},

			format_on_save = function()
				return { timeout_ms = 2000, lsp_format = "fallback" }
			end,
		},
		config = function(_, opts)
			require("conform").setup(opts)

			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({ async = false, lsp_format = "fallback", range = range })
			end, { range = true })

			keyMapper("<leader>fo", "<cmd>Format<cr>", "n")
		end,
	},
}
