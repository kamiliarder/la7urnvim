--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/init.lua
-- Description: init plugins config

-- Built-in plugins
local builtin_plugins = {
    { "nvim-lua/plenary.nvim" },
    -- Miscellaneous useful functions
    -- mini.misc
    {
        "nvim-mini/mini.misc",
        version = "*",
        config = function(_, opts)
            require("mini.misc").setup()
            -- Synchronize terminal emulator background with Neovim's background to remove
            -- possibly different color padding around Neovim instance
            MiniMisc.setup_termbg_sync()
        end,
    },
    -- File explore
    -- mini.files
    {
        "nvim-mini/mini.files",
        lazy = false,
        opts = require("plugins.configs.mini-files"),
        config = function(_, opts)
            require("mini.files").setup(opts)

            local show_dotfiles = true
            local filter_show = function(_)
                return true
            end
            local filter_hide = function(fs_entry)
                return not vim.startswith(fs_entry.name, ".")
            end

            local toggle_dotfiles = function()
                show_dotfiles = not show_dotfiles
                local new_filter = show_dotfiles and filter_show or filter_hide
                require("mini.files").refresh({ content = { filter = new_filter } })
            end

            local map_split = function(buf_id, lhs, direction, close_on_file)
                local rhs = function()
                    local new_target_window
                    local cur_target_window = require("mini.files").get_explorer_state().target_window
                    if cur_target_window ~= nil then
                        vim.api.nvim_win_call(cur_target_window, function()
                            vim.cmd("belowright " .. direction .. " split")
                            new_target_window = vim.api.nvim_get_current_win()
                        end)

                        require("mini.files").set_target_window(new_target_window)
                        require("mini.files").go_in({ close_on_file = close_on_file })
                    end
                end

                local desc = "Open in " .. direction .. " split"
                if close_on_file then
                    desc = desc .. " and close"
                end
                vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
            end

            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniFilesBufferCreate",
                callback = function(args)
                    local buf_id = args.data.buf_id

                    vim.keymap.set(
                        "n",
                        opts.mappings and opts.mappings.toggle_hidden or "g.",
                        toggle_dotfiles,
                        { buffer = buf_id, desc = "Toggle hidden files" }
                    )

                    map_split(buf_id, opts.mappings and opts.mappings.go_in_horizontal or "<C-w>s", "horizontal", false)
                    map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical or "<C-w>v", "vertical", false)
                    map_split(
                        buf_id,
                        opts.mappings and opts.mappings.go_in_horizontal_plus or "<C-w>S",
                        "horizontal",
                        true
                    )
                    map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical_plus or "<C-w>V", "vertical", true)
                end,
            })
        end,
    },
    -- Formatter
    -- Lightweight yet powerful formatter plugin for Neovim
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = { lua = { "stylua" } },
        },
    },
    -- Git integration for buffers
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile", "BufWritePost" },
        opts = function()
            require("plugins.configs.gitsigns")
        end,
    },
    -- Treesitter interface
    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old and doesn't work on Windows
        evevent = { "BufReadPost", "BufNewFile", "BufWritePost" },
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
        build = ":TSUpdate",
        opts = function()
            require("plugins.configs.treesitter")
        end,
    },
    -- Telescope
    -- Find, Filter, Preview, Pick. All lua, all the time.
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },
        cmd = "Telescope",
        config = function(_)
            require("telescope").setup()
            -- To get fzf loaded and working with telescope, you need to call
            -- load_extension, somewhere after setup function:
            require("telescope").load_extension("fzf")
            require("plugins.configs.telescope")
        end,
    },
    -- Statusline
    -- A blazing fast and easy to configure neovim statusline plugin written in pure lua.
    {
        "nvim-lualine/lualine.nvim",
        opts = function()
            require("plugins.configs.lualine")
        end,
    },
    -- colorscheme
    {
        -- Rose-pine - Soho vibes for Neovim
        "rose-pine/neovim",
        name = "rose-pine",
        opts = {
            dark_variant = "main",
        },
    },
    -- LSP stuffs
    -- Portable package manager for Neovim that runs everywhere Neovim runs.
    -- Easily install and manage LSP servers, DAP servers, linters, and formatters.
    {
        "mason-org/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
        config = function()
            require("plugins.configs.mason")
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
    },
    {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "nvimtools/none-ls-extras.nvim" },
        lazy = true,
        config = function()
            require("plugins.configs.null-ls")
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = "VimEnter",
        lazy = false,
        config = function()
            require("plugins.configs.lspconfig")
        end,
    },
    {
        "saghen/blink.cmp",
        version = "v0.*",
        build = "cargo build --release",
        timeout = 120,
        dependencies = {
            "rafamadriz/friendly-snippets",
            "Nash0x7E2/awesome-flutter-snippets",
            "zbirenbaum/copilot.lua",
            "giuxtaposition/blink-cmp-copilot",
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
            {
                "windwp/nvim-autopairs",
                config = function()
                    require("nvim-autopairs").setup({
                        check_ts = true,
                        disable_filetype = { "TelescopePrompt", "vim" },
                        enable_check_bracket_line = false,
                        ts_config = {
                            lua = { "string", "comment" },
                            javascript = { "string", "comment" },
                            typescript = { "string", "comment" },
                        },
                    })

                    local Rule = require("nvim-autopairs.rule")
                    local npairs = require("nvim-autopairs")

                    npairs.add_rules({
                        Rule(" ", " ")
                            :with_pair(function(opts)
                                local pair = opts.line:sub(opts.col - 1, opts.col)
                                return vim.tbl_contains({ "()", "[]", "{}" }, pair)
                            end)
                            :with_move(function(opts)
                                return opts.prev_char:match(".%) ") ~= nil
                            end)
                            :use_key(" "),
                        Rule("(", ")"):use_key("("),
                        Rule("[", "]"):use_key("["),
                        Rule("{", "}"):use_key("{"),
                    })
                end,
            },
        },
        event = "InsertEnter",
        opts = function()
            return require("plugins.configs.blink")
        end,
    },
    -- Colorizer
    {
        "norcalli/nvim-colorizer.lua",
        config = function(_)
            require("colorizer").setup()

            -- execute colorizer as soon as possible
            vim.defer_fn(function()
                require("colorizer").attach_to_buffer(0)
            end, 0)
        end,
    },
    -- Copilot
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    hide_during_completion = true, -- hide the ghost text when the completion menu is visible
                    debounce = 75,
                }, -- This will conflict and show 2 completion suggestions at the same time, so im adding an autocmd configuration to hide the ghost text when the completion menu is visible
                panel = { enabled = false }, -- Disabled to prevent conflicts with blink.cmp
            })
        end,
    },
    -- Keymappings
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").setup()
        end,
    },
    -- Dashboard inspiration
    -- Developer excuses for the dashboard
    -- Commented out inspire.nvim in favor of devexcuses.nvim
    -- {
    --     "RileyGabrielson/inspire.nvim",
    --     lazy = false,
    --     config = function()
    --         require("inspire").setup({})
    --     end,
    -- },
    -- Random dev excuses
    {
        "mahyarmirrashed/devexcuses.nvim",
        lazy = false,
        config = function()
            require("devexcuses").setup()
        end,
    },
    -- Dashboard
    -- Fast and fully programmable greeter for neovim
    {
        "goolord/alpha-nvim",
        lazy = false,
        dependencies = {
            "mahyarmirrashed/devexcuses.nvim",
        },
        config = function()
            require("plugins.configs.alpha")
        end,
    },
}

local exist, custom = pcall(require, "custom")
local custom_plugins = exist and type(custom) == "table" and custom.plugins or {}

-- Check if there is any custom plugins
-- local ok, custom_plugins = pcall(require, "plugins.custom")
require("lazy").setup({
    spec = { builtin_plugins, custom_plugins },
    lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json", -- lockfile generated after running update.
    defaults = {
        lazy = false, -- should plugins be lazy-loaded?
        version = nil,
        -- version = "*", -- enable this to try installing the latest stable versions of plugins
    },
    ui = {
        icons = {
            ft = "",
            lazy = "󰂠",
            loaded = "",
            not_loaded = "",
        },
    },
    install = {
        -- install missing plugins on startup
        missing = true,
        -- try to load one of these colorschemes when starting an installation during startup
        colorscheme = { "rose-pine", "habamax" },
    },
    checker = {
        -- automatically check for plugin updates
        enabled = true,
        -- get a notification when new updates are found
        -- disable it as it's too annoying
        notify = false,
        -- check for updates every day
        frequency = 86400,
    },
    change_detection = {
        -- automatically check for config file changes and reload the ui
        enabled = true,
        -- get a notification when changes are found
        -- disable it as it's too annoying
        notify = false,
    },
    performance = {
        cache = {
            enabled = true,
        },
    },
    state = vim.fn.stdpath("state") .. "/lazy/state.json", -- state info for checker and other things
})
