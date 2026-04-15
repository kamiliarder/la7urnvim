-- File: plugins/configs/blink.lua
-- Description: blink.cmp configuration

return {
    -- Use preset keymap if you want sensible defaults
    keymap = {
        preset = "default",
        -- Customize individual keys if needed
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "select_and_accept", "fallback" },
    },

    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
        kind_icons = {
            -- Icons are automatically fetched based on kind
            -- or you can customize like lspkind
        },
    },

    completion = {
        accept = { auto_brackets = { enabled = true } },
        -- Trigger window to show automatically
        menu = {
            auto_show = true,
            max_height = 10,
            border = "rounded",
            winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
            draw = {
                columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
                gap = 1,
            },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            update_delay_ms = 50,
            window = {
                max_height = 10,
                max_width = 60,
                border = "rounded",
                winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
            },
        },
    },

    -- Sources define what provides completions
    sources = {
        -- LSP is a default source, no need to specify
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
            copilot = {
                name = "copilot",
                module = "blink-cmp-copilot",
                score_offset = 100, -- Show copilot on the top suggestion
                async = true,
            },
        },
        -- Fine-tune source limits per category
        per_filetype = {
            dart = { "lsp", "path", "snippets", "buffer" },
            -- You can add another filetype if you want limited sources
        },
    },

    -- Signature help (shows function arguments while typing)
    signature = { enabled = true },

    -- Snippet configuration
    snippets = {
        preset = "luasnip",
    },
}
