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
        lazy = false,
        config = function()
            local manager = require("tree-sitter-manager")

            manager.setup({
                languages = {
                    org = {
                        install_info = {
                            url = "https://github.com/milisims/tree-sitter-org",
                        },
                    },
                },
                ensure_installed = {
                    "bash",
                    "c",
                    "elixir",
                    "fennel",
                    "html",
                    "lua",
                    "markdown",
                    "nix",
                    "nu",
                    "org",
                    "python",
                    "rust",
                    "scheme",
                    "typst",
                    "vim",
                    "vimdoc",
                },
                border = nil,
                auto_install = true,
                highlight = true,
            })

            local plugin_path = vim.fn.stdpath("data") .. "/lazy/tree-sitter-manager.nvim"
            vim.opt.runtimepath:append(plugin_path)
        end,
    },
}
