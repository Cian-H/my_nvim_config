return {
    {
        "lewis6991/gitsigns.nvim",
        event = "VimEnter",
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
    { -- Oil is a very nice buffer-based filetree editor
        "stevearc/oil.nvim",
        event = "VeryLazy",
        opts = {},
        keys = require("config.keys").oil,
    },
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
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
    },
    {
        "XXiaoA/atone.nvim",
        event = "VeryLazy",
        cmd = "Atone",
        keys = require("config.keys").atone,
        opts = {},
    },
}
