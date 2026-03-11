vim.bo.commentstring = "/// %s"

vim.bo.syntax = "ON" -- F# legacy syntax fallback

vim.api.nvim_set_hl(0, "@comment.documentation", { link = "Comment" })
vim.api.nvim_set_hl(0, "@comment.documentation.fsharp", { link = "Comment" })
vim.api.nvim_set_hl(0, "fsharpDocComment", { link = "Comment" })
