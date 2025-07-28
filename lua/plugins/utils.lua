return { -- General programming utilities go here
    -- Tools for configuration and plugin development
    { "folke/neoconf.nvim", cmd = "Neoconf" },
    {
        "folke/neodev.nvim",
        opts = {
            override = function(root_dir, library)
                if
                    root_dir:find(
                        os.getenv("XDG_CONFIG_HOME")
                            .. "/nix/home-manager/core/dotfiles/dot_config/nvim/",
                        1,
                        true
                    ) == 1
                then
                    library.enabled = true
                    library.plugins = true
                end
            end,
        },
    },
    -- Privilege escalation plugin
    { "lambdalisue/suda.vim", event = "VeryLazy" },
    {
        "folke/trouble.nvim",
        cmd = { "Trouble" },
        opts = {
            modes = {
                lsp = {
                    win = { position = "right" },
                },
            },
        },
        keys = require("config.keys").trouble,
    },
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = require("config.keys").todo_comments,
    },
    "tpope/vim-fugitive", -- Also want to add fugitive, since it's apparently a great git plugin
    "jlfwong/vim-mercenary", -- Mercenary is the mercurial equivalent of fugitive
    { -- Oil is a very nice buffer-based filetree editor
        "stevearc/oil.nvim",
        event = "VeryLazy",
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = require("config.keys").oil,
    },
    { -- Harpoon, because i keep losing track of my markers
        "theprimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("harpoon"):setup({})
        end,
        keys = require("config.keys").harpoon,
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
    { -- Autoformat
        "stevearc/conform.nvim",
        event = "VimEnter",
        opts = {
            notify_on_error = false,
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                lua = { "stylua" },
                nix = { "alejandra" },
                -- Conform can also run multiple formatters sequentially
                -- python = { "isort", "black" },
                --
                -- You can use a sub-list to tell conform to run *until* a formatter
                -- is found.
                -- javascript = { { "prettierd", "prettier" } },
            },
        },
    },
    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "bash", "c", "html", "lua", "markdown", "vim", "vimdoc" },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        },
        config = function(_, opts)
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup(opts)
        end,
        dependencies = {
            { "nushell/tree-sitter-nu", build = ":TSUpdate nu" },
        },
    },
    { -- Undo tree
        "mbbill/undotree",
        event = "VeryLazy",
        opts = {},
        config = function()
            vim.keymap.set("n", "U", vim.cmd.UndotreeToggle, { desc = "[U]ndotree" })
        end,
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
    -- Rust tools like inlay hints are absolutely essential
    { "simrat39/rust-tools.nvim", ft = "rust" },
}
