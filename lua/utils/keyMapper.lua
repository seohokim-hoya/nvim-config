local function mapKey(lhs, rhs, mode, opts)
    local options = { noremap = true, silent = true }

    -- mode/opts 인자 유연 처리:
    -- mapKey(lhs, rhs)
    -- mapKey(lhs, rhs, "n")
    -- mapKey(lhs, rhs, { "n", "t" })
    -- mapKey(lhs, rhs, { desc = "..." })            -- mode 생략 + opts만
    -- mapKey(lhs, rhs, "n", { desc = "..." })
    if type(mode) == "table" and opts == nil then
        opts = mode
        mode = nil
    end

    mode = mode or "n"

    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    vim.keymap.set(mode, lhs, rhs, options)
end

return { mapKey = mapKey }
