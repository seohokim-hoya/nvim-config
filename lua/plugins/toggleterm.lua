return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = function()
                return math.floor(vim.o.columns * 0.95)
            end,
            open_mapping = [[<S-A-H>]],
            direction = "float",
            float_opts = {
                border = "curved",
            },
        })
    end,
}
