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
        event = "VimEnter",
        config = function()
            local wk = require("which-key")
            local groups = require("config.keys").groups
            wk.add(groups)
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
            require("window-picker").setup()
        end,
    },
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        "mhinz/vim-signify",
        event = "VimEnter",
        config = function()
            -- defer config for 5ms. Old vim plugins can be janky in neovim
            vim.defer_fn(function()
                vim.g.signify_sign_show_count = 0
                vim.g.signify_sign_add = "┃"
                vim.g.signify_sign_change = "┃"
                vim.g.signify_sign_delete = "_"
                vim.g.signify_sign_delete_first_line = "‾"
                vim.g.signify_sign_change_delete = "~"
                vim.cmd.highlight({ "SignifySignAdd", "guifg=#449dab" })
                vim.cmd.highlight({ "SignifySignChange", "guifg=#6183bb" })
                vim.cmd.highlight({ "SignifySignDelete", "guifg=#914c54" })
                vim.cmd.highlight({ "link", "SignifySignDeleteFirstLine", "SignifySignDelete" })
                vim.cmd.highlight({ "link", "SignifySignChangeDelete", "SignifySignChange" })
            end, 5)
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
                        { "copilot", show_colors = true },
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
    {
        "AndreM222/copilot-lualine",
        event = "VeryLazy",
        dependencies = { "zbirenbaum/copilot.lua" },
    },
    -- Assistant for refreshers on vim motions
    {
        "tris203/precognition.nvim",
        keys = require("config.keys").precognition,
    },
}
