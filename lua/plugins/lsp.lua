local keyMapper = require("utils.keyMapper").mapKey

local lsp_servers = {
	-- Lua
	"lua_ls",

	-- Python
	"pyright",
	"ruff",

	-- C / CMake
	"clangd",
	"cmake",

	-- Markdown / JSON / YAML
	"marksman",
	"jsonls",
	"yamlls",

	-- Docker
	"dockerls",
	"docker_compose_language_service",

	-- JS / TS
	"ts_ls",

	-- Rust
	"rust_analyzer",

	-- TOML / Shell / Tailwind / Typo / TeX
	"taplo",
	"bashls",
	"tailwindcss",
	"typos_lsp",
	"texlab",
}

local mason_tools = {
	"stylua",
	"shfmt",
	"black",
	"isort",
	"prettierd",
	"prettier",
	"clang-format",
}

local formatters_by_ft = {
	lua = { "stylua" },
	python = { "isort", "black" },

	javascript = { "prettierd", "prettier", stop_after_first = true },
	typescript = { "prettierd", "prettier", stop_after_first = true },
	json = { "prettierd", "prettier", stop_after_first = true },
	yaml = { "prettierd", "prettier", stop_after_first = true },
	markdown = { "prettierd", "prettier", stop_after_first = true },

	c = { "clang-format" },
	cpp = { "clang-format" },
	sh = { "shfmt" },
	rust = { "rustfmt" },
}

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
			-- JS/TS formatting is handled by conform (prettierd/prettier)
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

local function setup_curline_diagnostics()
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
						virt_texts[#virt_texts + 1] = {
							diag.message,
							"Diagnostic" .. hi[diag.severity],
						}
					end

					vim.api.nvim_buf_set_extmark(args.buf, ns, curline - 1, 0, {
						virt_text = virt_texts,
						hl_mode = "combine",
					})
				end,
			})
		end,
	})
end

return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = mason_tools,
		},
		---@param opts MasonSettings | { ensure_installed: string[] }
		config = function(_, opts)
			local ensure_installed = opts.ensure_installed or {}
			opts.ensure_installed = nil

			require("mason").setup(opts)

			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			mr.refresh(function()
				for _, tool in ipairs(ensure_installed) do
					local ok, pkg = pcall(mr.get_package, tool)
					if ok and not pkg:is_installed() then
						pkg:install()
					end
				end
			end)
		end,
	},

	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = lsp_servers,
			automatic_enable = false,
		},
	},

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
			if not (vim.lsp and vim.lsp.config and vim.lsp.enable) then
				vim.notify(
					"이 설정은 Neovim 0.11+의 vim.lsp.config/vim.lsp.enable API가 필요합니다.",
					vim.log.levels.ERROR
				)
				return
			end

			local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = ok_cmp and cmp_nvim_lsp.default_capabilities()
				or vim.lsp.protocol.make_client_capabilities()

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			for name, cfg in pairs(server_configs) do
				vim.lsp.config(name, cfg)
			end

			local ok_enable, err = pcall(vim.lsp.enable, lsp_servers)
			if not ok_enable then
				vim.notify(("vim.lsp.enable 실패: %s"):format(err), vim.log.levels.WARN)
			end

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

			setup_curline_diagnostics()
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo", "Format", "FormatDisable", "FormatEnable" },
		keys = {
			{ "<leader>fo", "<cmd>Format<cr>", mode = "n", desc = "Format buffer" },
		},
		opts = {
			formatters_by_ft = formatters_by_ft,
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { timeout_ms = 2000 }
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

				require("conform").format({
					async = false,
					lsp_format = "fallback",
					range = range,
				})
			end, { range = true })

			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})

			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})
		end,
	},

	{
		"scalameta/nvim-metals",
		ft = { "scala", "sbt", "java" },
		opts = function()
			local metals_config = require("metals").bare_config()
			metals_config.on_attach = function(_, _)
				-- custom on_attach
			end
			return metals_config
		end,
		config = function(self, metals_config)
			local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				pattern = self.ft,
				callback = function()
					require("metals").initialize_or_attach(metals_config)
				end,
				group = nvim_metals_group,
			})
		end,
	},
}
