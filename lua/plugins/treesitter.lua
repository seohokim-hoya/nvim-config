return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		local uv = vim.uv or vim.loop

		ts.setup({
			-- main 재작성 버전은 install_dir이 runtimepath 우선순위로 들어감
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		-- no-op이면 빠르게 끝나지만, 필요한 것들은 미리 박아두는 게 편함
		ts.install({
			"lua",
			"vim",
			"vimdoc",
			"query",
			"javascript",
			"typescript",
			"tsx",
			"php",
		})

		local group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })

		local function is_big_file(buf)
			local name = vim.api.nvim_buf_get_name(buf)
			if name == "" then
				return false
			end
			local ok, stat = pcall(uv.fs_stat, name)
			return ok and stat and stat.size and stat.size > (1024 * 1024) -- 1MB
		end

		local indent_ft = {
			lua = true,
			typescript = true,
			typescriptreact = true,
			javascript = true,
			javascriptreact = true,
			php = true,
		}

		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = {
				"lua",
				"vim",
				"typescript",
				"typescriptreact",
				"javascript",
				"javascriptreact",
				"php",
			},
			callback = function(args)
				if is_big_file(args.buf) then
					return
				end

				-- main 재작성 버전: 하이라이트 등은 FileType에서 start 해줘야 함
				pcall(vim.treesitter.start)

				-- 인덴트(실험적): 원하는 언어에서만 켬
				local ft = vim.bo[args.buf].filetype
				if indent_ft[ft] then
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end

				-- folds (원하면)
				vim.wo.foldmethod = "expr"
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo.foldlevel = 99
			end,
		})
	end,
}
