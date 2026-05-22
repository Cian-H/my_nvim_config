return {
    { -- Autoformat
        "stevearc/conform.nvim",
        event = "VimEnter",
        opts = {
            notify_on_error = false,
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        },
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                "~/.config/nvim/",
                "~/.config/nix/home-manager/core/dotfiles/dot_config/nvim/",
            },
        },
    },
    { -- Package and devenv plugins
        "danymat/neogen",
        event = "VimEnter",
        config = function()
            require("neogen").setup({
                enabled = true,
                snippet_engine = "luasnip",
                languages = {
                    python = {
                        template = {
                            annotation_convention = "google_docstrings",
                        },
                    },
                },
            })
        end,
        keys = require("config.keys").neogen,
    },
    { -- A plugin to integrate tests is helpful, so i'm adding neotest
        "nvim-neotest/neotest",
        event = "VeryLazy",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "romus204/tree-sitter-manager.nvim",
        },
    },
    { -- Tools for configuration and plugin development
        "klen/nvim-config-local",
        lazy = false, -- Load immediately to ensure it catches the initial working directory
        opts = {
            config_files = { ".nvim.lua", ".nvimrc", ".exrc" },
            hashfile = vim.fn.stdpath("data") .. "/config-local",
            autocommands_create = true,
            commands_create = true,
            silent = false,
            lookup_parents = true,
        },
    },
    { -- Add Overseer as a task running tool
        "stevearc/overseer.nvim",
        event = "VeryLazy",
        opts = {},
        config = function()
            require("overseer").setup()
        end,
        keys = require("config.keys").overseer,
    },
    {
        "romus204/tree-sitter-manager.nvim",
        dependencies = {},
        config = function()
            require("tree-sitter-manager").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "elixir",
                    "html",
                    "lua",
                    "markdown",
                    "nix",
                    "nu",
                    "python",
                    "rust",
                    "scheme",
                    "typst",
                    "vim",
                    "vimdoc",
                },
                border = nil,
                auto_install = false,
                highlight = true,
            })
            -- Automatically attach treesitter to buffers
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "*",
                callback = function()
                    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
                    if lang and vim.treesitter.query.get(lang, "highlights") then
                        pcall(vim.treesitter.start)
                    end
                end,
                group = vim.api.nvim_create_augroup("ts_native_highlight", { clear = true }),
            })
        end,
    },
}
