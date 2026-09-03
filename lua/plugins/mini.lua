return { -- Mini is so varied it's hard to categorise. So i dumped my mini installs here
    { -- Collection of various small independent plugins/modules
        "echasnovski/mini.nvim",
        config = function()
            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require("mini.ai").setup({ n_lines = 500 })

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require("mini.surround").setup()

            local icons = require("config.icons")
            require("mini.icons").setup({
                extension = {
                    scl = { glyph = icons.Scallop.icon, hl = "MiniIconsRed" },
                    prolog = { glyph = icons.Prolog.icon, hl = "MiniIconsYellow" },
                    pro = { glyph = icons.Prolog.icon, hl = "MiniIconsYellow" },
                    lisp = { glyph = icons.Lisp.icon, hl = "MiniIconsRed" },
                    lsp = { glyph = icons.Lisp.icon, hl = "MiniIconsRed" },
                    asd = { glyph = icons.Lisp.icon, hl = "MiniIconsRed" },
                    f = { glyph = icons.Fortran.icon, hl = "MiniIconsPurple" },
                    f77 = { glyph = icons.Fortran.icon, hl = "MiniIconsPurple" },
                    f90 = { glyph = icons.Fortran.icon, hl = "MiniIconsPurple" },
                    f18 = { glyph = icons.Fortran.icon, hl = "MiniIconsPurple" },
                    adb = { glyph = icons.Ada.icon, hl = "MiniIconsYellow" },
                    ads = { glyph = icons.Ada.icon, hl = "MiniIconsYellow" },
                },
            })
            require("mini.icons").mock_nvim_web_devicons()

            require("mini.deps").setup() -- For per-project/dynamic plugin loading
            require("mini.visits").setup()
            require("mini.sessions").setup()
            require("mini.pairs").setup({ mappings = { ["`"] = false } })
            require("mini.splitjoin").setup()
            require("mini.trailspace").setup({ only_in_normal_buffers = true })

            -- My custom mini.starter config
            ---@class StarterItem
            ---@field name string
            ---@field action string|function
            ---@field section string

            ---@type StarterItem[]
            local starter_items = {
                {
                    action = "lua Snacks.picker.files()",
                    name = "File grep",
                    section = "Snacks",
                },
                {
                    action = "lua Snacks.picker.grep()",
                    name = "Live grep",
                    section = "Snacks",
                },
                {
                    action = "lua Snacks.picker.explorer()",
                    name = "Tree",
                    section = "Snacks",
                },
                {
                    action = "lua Snacks.picker.help()",
                    name = "Help tags",
                    section = "Snacks",
                },
                {
                    name = "Log",
                    action = [[lua Snacks.lazygit.log()]],
                    section = "Git",
                },
                {
                    name = "Lazygit",
                    action = [[lua Snacks.lazygit()]],
                    section = "Git",
                },
                {
                    name = "Browser",
                    action = "lua Snacks.gitbrowse()",
                    section = "Git",
                },
            }
            require("mini.starter").setup({
                header = "⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\
⠀⠀⠀⠀⠀⠀⢀⣴⣾⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\
⠀⠀⠀⠀⢀⣴⠿⢟⣛⣩⣤⣶⣶⣶⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\
⠀⠀⢀⣴⣿⠿⠸⣿⣿⣿⣿⣿⣿⡿⢿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\
⠀⢠⠞⠉⠀⠀⠀⣿⠋⠻⣿⣿⣿⠀⣦⣿⠏⠀⠀⠀⢀⣀⣀⣀⣀⣀⠀⠀\
⢠⠏⠀⠀⠀⠀⠀⠻⣤⣷⣿⣿⣿⣶⢟⣁⣒⣒⡋⠉⠉⠁⠀⠀⠀⠈⠉⡧\
⢻⡀⠀⠀⠀⠀⠀⣀⡤⠌⢙⣛⣛⣵⣿⣿⡛⠛⠿⠃⠀⠀⠀⠀⠀⢀⡜⠁\
⠀⠉⠙⠒⠒⠛⠉⠁⠀⠸⠛⠉⠉⣿⣿⣿⣿⣦⣄⠀⠀⠀⢀⣠⠞⠁⠀⠀\
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⡿⣿⣿⣷⡄⠞⠋⠀⠀⠀⠀⠀\
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣷⡻⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀\
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢨⣑⡙⠻⠿⠿⠈⠙⣿⣧⠀⠀⠀⠀⠀⠀\
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣷⡀⠀⠀⠀⠀⢹⣿⣆⠀⠀⠀⠀⠀\
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⡇⠀⠀⠀⠀⠸⣿⣿⡄⠀⠀⠀⠀\
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⡿⣿⣿⠀⠀⠀⠀\
⠀⠀⠀⠀⠀⠀⠀       ⠀⠀⠀⠀⠀⠀⠀⠈⠙⠀⠀⠀⠀⠀",
                items = starter_items,
                footer = "",
            })
        end,
    },
}
