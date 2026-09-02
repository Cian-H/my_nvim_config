return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            lazygit = { enabled = true },
            quickfile = { enabled = true },
            picker = { enabled = true },
            explorer = { enabled = true },
            notifier = { enabled = true, timeout = 3000 },
            input = { enabled = true },
            scope = { enabled = true },
            words = { enabled = true },
        },
        keys = require("config.keys").lazygit,
    },
}
