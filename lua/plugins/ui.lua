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
            local commands = require("config.keys").commands
            wk.add(groups)
            wk.add(commands)
        end,
    },
    {
        "nvim-tree/nvim-web-devicons",
        config = function()
            local icons = require("config.icons")
            require("nvim-web-devicons").setup({
                color_icons = true,
                override_by_extension = {
                    ["scl"] = icons.Scallop,
                    ["prolog"] = icons.Prolog,
                    ["pro"] = icons.Prolog,
                    ["lisp"] = icons.Lisp,
                    ["lsp"] = icons.Lisp,
                    ["asd"] = icons.Lisp,
                    ["f"] = icons.Fortran,
                    ["f77"] = icons.Fortran,
                    ["f90"] = icons.Fortran,
                    ["f18"] = icons.Fortran,
                    ["adb"] = icons.Ada,
                    ["ads"] = icons.Ada,
                },
            })
        end,
    },
    { -- A file explorer, because i'm not used to the vim workflow yet
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        event = "VimEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        keys = require("config.keys").neotree,
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
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local hl_color = require("tokyonight").load({ style = "night" }).orange
            vim.cmd.highlight({ "LualineHarpoonActive", "guifg=" .. hl_color })

            require("lualine").setup({
                options = {
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_c = {
                        {
                            "harpoon2",
                            icon = "󰛢",
                            indicators = { "A", "S", "D", "F" },
                            active_indicators = {
                                "%#LualineHarpoonActive#A%*",
                                "%#LualineHarpoonActive#S%*",
                                "%#LualineHarpoonActive#D%*",
                                "%#LualineHarpoonActive#F%*",
                            },
                            _separator = "∙",
                            no_harpoon = "Harpoon not loaded",
                        },
                        "filename",
                    },
                    lualine_x = {
                        "encoding",
                        "fileformat",
                        "filetype",
                    },
                },
                extensions = {
                    "fugitive",
                    "fzf",
                    "lazy",
                    "mason",
                    "neo-tree",
                    "oil",
                    "overseer",
                    "quickfix",
                },
            })
        end,
    },
    {
        "letieu/harpoon-lualine",
        dependencies = {
            {
                "ThePrimeagen/harpoon",
                branch = "harpoon2",
            },
        },
    },
    -- Assistant for refreshers on vim motions
    {
        "tris203/precognition.nvim",
        keys = require("config.keys").precognition,
    },
    {
        "HiPhish/rainbow-delimiters.nvim",
        lazy = true,
        keys = require("config.keys").rainbow_delimiters,
        config = function()
            require("rainbow-delimiters.setup").setup({})
        end,
    },
}
