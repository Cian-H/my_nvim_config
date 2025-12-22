return {
    {
        "lewis6991/gitsigns.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "┃" },
                    change = { text = "┃" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
            })
        end,
        keys = require("config.keys").gitsigns,
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
    { -- Definitely need to add a plugin for quickly making notes in obsidian
        "epwalsh/obsidian.nvim",
        version = "*",
        cmd = "Obsidian",
        event = "VeryLazy",
        cond = function()
            return vim.fn.executable("obsidian") == 1
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = function()
            local target_path = vim.fn.expand("~/Documents/Work_Notes/")
            local workspaces = {}

            if vim.fn.isdirectory(target_path) == 1 then
                table.insert(workspaces, {
                    name = "work",
                    path = target_path,
                })
            end

            if #workspaces == 0 then
                local fallback_path = vim.fn.stdpath("data") .. "/obsidian_fallback"
                if vim.fn.isdirectory(fallback_path) == 0 then
                    vim.fn.mkdir(fallback_path, "p")
                end

                table.insert(workspaces, {
                    name = "fallback",
                    path = fallback_path,
                })

                vim.notify(
                    "Obsidian: 'Work_Notes' not found. Using fallback path.",
                    vim.log.levels.WARN
                )
            end

            return {
                workspaces = workspaces,
                completion = {
                    min_chars = 2,
                },
            }
        end,
    },
    { -- Oil is a very nice buffer-based filetree editor
        "stevearc/oil.nvim",
        event = "VeryLazy",
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = require("config.keys").oil,
    },
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = require("config.keys").todo_comments,
    },
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
    { -- Undo tree
        "mbbill/undotree",
        event = "VeryLazy",
        keys = require("config.keys").undotree,
    },
}
