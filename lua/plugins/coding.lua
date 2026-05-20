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
            "nvim-treesitter/nvim-treesitter",
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
    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        opts = {
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
                "quarto",
                "rust",
                "scheme",
                "typst",
                "vim",
                "vimdoc",
            },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        },
        config = function()
            local treesitter = require("nvim-treesitter")
            treesitter.setup()
            treesitter.install = {
                "bash",
                "c",
                "elixir",
                "html",
                "lua",
                "markdown",
                "nix",
                "nu",
                "python",
                "quarto",
                "rust",
                "scheme",
                "typst",
                "vim",
                "vimdoc",
            }

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "*",
                callback = function(args)
                    local filetype = vim.bo[args.buf].filetype

                    if filetype == "" or vim.bo[args.buf].buftype ~= "" then
                        return
                    end

                    local lang = vim.treesitter.language.get_lang(filetype) or filetype
                    local has_parser = vim.treesitter.language.add(lang)

                    if has_parser then
                        local success = pcall(vim.treesitter.start, args.buf, lang)
                        if success then
                            vim.bo[args.buf].indentexpr =
                                "v:lua.require'nvim-treesitter'.indentexpr()"
                        end
                    end
                end,
            })
        end,
    },
}
