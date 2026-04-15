-- Dashboard configuration for alpha-nvim with devexcuses.nvim integration

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Get an excuse from devexcuses.nvim
local function get_excuse()
    local ok, devexcuses = pcall(require, "devexcuses")
    if ok and devexcuses.get_excuse then
        local ok_excuse, excuses = pcall(devexcuses.get_excuse, 1)
        if ok_excuse and excuses and #excuses > 0 then
            return excuses[1].excuse or "Why did you close Neovim?"
        end
    end
    return "Why did you close Neovim?"
end

-- Header art - "lazur" in minimalist modern style
dashboard.section.header.val = {
    "     ██╗      █████╗ ███████╗██╗   ██╗██████╗ ",
    "     ██║     ██╔══██╗╚════██║██║   ██║██╔══██╗",
    "     ██║     ███████║    ██╔╝██║   ██║██████╔╝",
    "     ██║     ██╔══██║   ██╔╝ ██║   ██║██╔══██╗",
    "     ███████╗██║  ██║   ██║  ╚██████╔╝██║  ██║",
    "     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚═╝  ╚═╝",
}

-- Menu items
dashboard.section.buttons.val = {
    dashboard.button("e", "📄 New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("f", "🔍 Find file", ":Telescope find_files <CR>"),
    dashboard.button("r", "⏱️  Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("g", "🔎 Live grep", ":Telescope live_grep <CR>"),
    dashboard.button("m", "📁 File explorer", ":MiniFiles <CR>"),
    dashboard.button("l", "📋 Last session", ":lua require('persistence').load() <CR>"),
    dashboard.button("q", "❌ Quit", ":qa<CR>"),
}

-- Footer with dev excuse from devexcuses.nvim
dashboard.section.footer.val = {
    "",
    get_excuse(),
}

-- Configure layout spacing
dashboard.config.layout = {
    { type = "padding", val = 8 },
    dashboard.section.header,
    { type = "padding", val = 2 },
    dashboard.section.buttons,
    { type = "padding", val = 1 },
    dashboard.section.footer,
}

-- Set highlight groups for better appearance
local highlights = {
    AlphaHeader = { fg = "#ffb4ac", bold = true },
    AlphaButtons = { fg = "#c3e88d" },
    AlphaFooter = { fg = "#a3be8c", italic = true },
    AlphaShortcut = { fg = "#89ddff", bold = true },
}

for group, hl in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, hl)
end

-- Apply the highlights to sections
dashboard.section.header.opts.hl = "AlphaHeader"
dashboard.section.buttons.opts.hl_shortcut = "AlphaShortcut"
dashboard.section.footer.opts.hl = "AlphaFooter"

alpha.setup(dashboard.config)

-- Auto-close alpha when opening a file from command line
vim.api.nvim_create_autocmd("User", {
    pattern = "AlphaReady",
    callback = function()
        -- Set up autocmd to close alpha when opening a real file
        vim.api.nvim_create_autocmd("BufNew", {
            callback = function(event)
                local buf_type = vim.bo[event.buf].buftype
                if buf_type ~= "nofile" and buf_type ~= "" then
                    vim.api.nvim_buf_delete(vim.fn.bufnr("alpha"), { force = true })
                end
            end,
            once = true,
        })
    end,
})
