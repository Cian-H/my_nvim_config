return { -- Mini is so varied it's hard to categorise. So i dumped my mini installs here
    {    -- Collection of various small independent plugins/modules
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

            -- Setup of mini.notify
            local notify = require("mini.notify")
            notify.setup()
            vim.notify = notify.make_notify({
                ERROR = { duration = 5000 },
                WARN = { duration = 4000 },
                INFO = { duration = 3000 },
            })

            require("mini.deps").setup() -- For per-project/dynamic plugin loading

            require("mini.pairs").setup({ mappings = { ["`"] = false } })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "rust",
                callback = function()
                    vim.b.minipairs_config = vim.tbl_deep_extend("force", require("mini.pairs").config, {
                        mappings = { ["'"] = false },
                    })
                end,
            })

            -- Some other mini.nvim plugins that look useful to me
            require("mini.clue").setup()
            require("mini.visits").setup()
            require("mini.sessions").setup()
            require("mini.comment").setup()
            require("mini.splitjoin").setup()
            require("mini.trailspace").setup()

            -- My custom mini.starter config
            local starter_items = {
                {
                    action = "Telescope file_browser",
                    name = "Tree",
                    section = "Telescope",
                },
                {
                    action = "Telescope live_grep",
                    name = "Live grep",
                    section = "Telescope",
                },
                {
                    action = "Telescope find_files",
                    name = "File grep",
                    section = "Telescope",
                },
                {
                    action = "Telescope command_history",
                    name = "Command history",
                    section = "Telescope",
                },
                {
                    action = "Telescope help_tags",
                    name = "Help tags",
                    section = "Telescope",
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
                    action = function()
                        local handle = io.popen("git remote show")
                        if handle == nil then
                            vim.notify("Failed to find remote", vim.log.levels.ERROR)
                            return
                        end
                        local result = handle:read("*a")
                        handle:close()
                        local remote = vim.split(result, "\n")[1]
                        handle = io.popen("git remote get-url " .. remote)
                        if handle == nil then
                            vim.notify("Failed to get url for " .. remote, vim.log.levels.ERROR)
                            return
                        end
                        local url = handle:read("*a")
                        handle:close()
                        handle = io.popen("xdg-open " .. url)
                        if handle == nil then
                            vim.notify("Failed to open " .. url, vim.log.levels.ERROR)
                            return
                        end
                        result = handle:read("*a")
                        handle:close()
                    end,
                    section = "Git",
                },
                {
                    name = "Harpoon Quickmenu",
                    action = [[lua require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())]],
                    section = "Misc",
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
