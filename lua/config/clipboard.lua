local is_wsl = vim.fn.has("wsl") == 1

if is_wsl then
	vim.g.clipboard = {
		name = "win32yank-wsl",
		copy = {
			["+"] = "win32yank.exe -i --crlf",
			["*"] = "win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "win32yank.exe -o --lf",
			["*"] = "win32yank.exe -o --lf",
		},
		cache_enabled = 0,
	}
elseif vim.fn.has("linux") == 1 then
	local has_wl_clipboard = vim.fn.executable("wl-copy") == 1 and vim.fn.executable("wl-paste") == 1
	local has_xclip = vim.fn.executable("xclip") == 1

	if has_wl_clipboard then
		vim.g.clipboard = {
			name = "wl-clipboard",
			copy = {
				["+"] = "wl-copy --foreground --type text/plain",
				["*"] = "wl-copy --foreground --primary --type text/plain",
			},
			paste = {
				["+"] = "wl-paste --no-newline",
				["*"] = "wl-paste --no-newline --primary",
			},
			cache_enabled = 0,
		}
	elseif has_xclip then
		vim.g.clipboard = {
			name = "xclip",
			copy = {
				["+"] = "xclip -quiet -i -selection clipboard",
				["*"] = "xclip -quiet -i -selection primary",
			},
			paste = {
				["+"] = "xclip -o -selection clipboard",
				["*"] = "xclip -o -selection primary",
			},
			cache_enabled = 0,
		}
	end
end

vim.opt.clipboard = "unnamedplus"
