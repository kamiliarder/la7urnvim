return {
    "ethan-declarative/blink.nvim",
    -- event = "VeryLazy",
    config = function()
        require("blink").setup({
            autocmd = {
                debounce = 100,
            },
            kind = {
                format = function(entry)
                    return ("%s %s"):format(entry.kind, entry.word)
                end,
            },
            sources = {},
        })
    end,
}
