return { -- UI components and other visual elements are declared here
    { -- Theme
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        init = function()
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },
    { "MunifTanjim/nui.nvim", lazy = true },
    { -- Useful plugin to show you pending keybinds.
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local wk = require("which-key")
            wk.setup({ preset = "modern" })
            local groups = require("config.keys").groups
            wk.add(groups)
        end,
    },
    {
        "s1n7ax/nvim-window-picker",
        name = "window-picker",
        event = "VeryLazy",
        version = "2.*",
        config = function()
            ---@diagnostic disable-next-line: undefined-field
            require("window-picker").setup()
        end,
    },
    -- Modular, configurable status bar
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = {
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_c = { "filename" },
                    lualine_x = {
                        "encoding",
                        "fileformat",
                        "filetype",
                    },
                },
                extensions = {
                    "lazy",
                    "mason",
                    "oil",
                    "overseer",
                    "quickfix",
                },
            })
        end,
    },
    {
        "HiPhish/rainbow-delimiters.nvim",
        lazy = true,
        ft = { "clojure", "fennel", "scheme", "lisp", "janet", "racket", "hy", "elisp" },
        keys = require("config.keys").rainbow_delimiters,
        config = function()
            require("rainbow-delimiters.setup").setup({})
        end,
    },
}
