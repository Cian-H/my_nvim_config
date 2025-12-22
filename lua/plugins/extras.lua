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
