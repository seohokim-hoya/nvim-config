return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		vim.g.vimtex_view_method = "sioyek"
		vim.g.vimtex_view_sioyek_exe = "/mnt/c/Tools/Sioyek/sioyek.exe"
		-- Use the Windows executable explicitly so Sioyek does not depend on PATH resolution for `wsl`.
		vim.g.vimtex_callback_progpath = "C:/Windows/System32/wsl.exe nvim"
		-- vim.g.vimtex_compiler_method = "latexmk"
		-- vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
	end,
	-- ft = { "tex" },
	-- config = function()
	-- 	vim.g.vimtex_compiler_method = "latexmk"
	--
	-- 	local is_wsl = vim.fn.has("wsl") == 1
	-- 	local is_mac = vim.fn.has("mac") == 1
	-- 	local is_linux = vim.fn.has("unix") == 1 and not is_mac
	--
	-- 	if is_wsl then
	-- 		-- 1) SumatraPDF 우선 (있으면 forward-search까지 가능)
	-- 		vim.g.vimtex_view_method = "general"
	-- 		vim.g.vimtex_view_general_viewer = "SumatraPDF.exe"
	-- 		vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line -inverse-search "nvim --server \\\\wsl$\\\\'
	-- 			.. (vim.env.WSL_DISTRO_NAME or "Ubuntu")
	-- 			.. "\\\\home\\\\"
	-- 			.. (vim.env.USER or "")
	-- 			.. "\\\\"
	-- 			.. '" @tex -reverse-search @line @pdf" @pdf'
	--
	-- 	-- 2) SumatraPDF가 PATH에 없으면 그냥 기본 앱으로 열기 (fallback)
	-- 	-- vimtex는 "general" viewer로 커맨드만 실행하니까, 확실한 fallback을 원하면 아래로 교체:
	-- 	-- vim.g.vimtex_view_general_viewer = "cmd.exe"
	-- 	-- vim.g.vimtex_view_general_options = '/c start "" @pdf'
	-- 	elseif is_mac then
	-- 		vim.g.vimtex_view_method = "skim"
	-- 	elseif is_linux then
	-- 		-- zathura가 있으면 그게 제일 안정적
	-- 		if vim.fn.executable("zathura") == 1 then
	-- 			vim.g.vimtex_view_method = "zathura"
	-- 		else
	-- 			vim.g.vimtex_view_method = "general"
	-- 			vim.g.vimtex_view_general_viewer = "xdg-open"
	-- 			vim.g.vimtex_view_general_options = "@pdf"
	-- 		end
	-- 	end
	-- end,
}
