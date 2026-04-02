return {
	"mg979/vim-visual-multi",
	branch = "master",
	-- Lazy loading을 위해 자주 사용하는 키맵을 등록합니다.
	keys = {

		{ "<C-n>", mode = { "n", "x" }, desc = "Multiple cursors (Find under)" },
		{ "<S-Down>", mode = { "n", "x" }, desc = "Multiple cursors (Add down)" },

		{ "<S-Up>", mode = { "n", "x" }, desc = "Multiple cursors (Add up)" },
	},
	init = function()
		-- 기본 리더키(\) 충돌 방지 및 테마 설정
		vim.g.VM_theme = "iceblue"
		vim.g.VM_maps = {
			["Find Under"] = "<C-n>", -- 현재 단어 선택 및 다음 단어 찾기
			["Find Subword Under"] = "<C-n>", -- (Visual 모드) 선택 영역과 동일한 다음 영역 찾기
			["Add Cursor Down"] = "<S-Down>", -- 아래로 커서 추가
			["Add Cursor Up"] = "<S-Up>", -- 위로 커서 추가
		}
	end,
}
