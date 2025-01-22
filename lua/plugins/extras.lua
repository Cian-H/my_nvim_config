return { -- Non programming quality of life utilities go here
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
        opts = {
            workspaces = {
                {
                    name = "work",
                    path = "~/Documents/Work_Notes/",
                },
            },
            completion = {
                nvim_cmp = true,
                min_chars = 2,
            },
        },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {},
        ft = "markdown",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "echasnovski/mini.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
    },
    { -- A cheatsheet will always be useful until im a bit more familiar with vim
        "sudormrfbin/cheatsheet.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/popup.nvim",
            "nvim-lua/plenary.nvim",
        },
    },
}
