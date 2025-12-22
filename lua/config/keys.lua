---@class Keymap
---@field [1] string LHS key
---@field [2] string|function RHS command or function
---@field desc string Description for which-key/vim.keymap
---@field mode? string|string[] Mode (n, v, i, etc.)
---@field expr? boolean Whether to use expression mapping

---@class KeyConfig : table<string, Keymap>

---@type KeyConfig
return {
    groups = {
        { "<leader>s", group = "[S]earch", icon = "" },
        { "<leader>c", group = "[C]ode", icon = "" },
        { "<leader>d", group = "[D]iagnostics", icon = "" },
        { "<leader>g", group = "[G]it", icon = "󰊢" },
        { "<leader>r", group = "[R]ename", icon = "󰑕" },
        { "<leader>w", group = "[W]orkspace", icon = "" },
        { "<leader>t", group = "[T]ree", icon = "󱏒" },
        { "<leader>l", group = "[L]azyGit", icon = "󰒲" },
        { "<leader>o", group = "[O]verseer", icon = "󰈈" },
        { "<leader>h", group = "[H]arpoon", icon = "󱡀" },
        { "<leader>x", group = "[X] Trouble", icon = "󰋔" },
    },
    commands = {
        { "<leader>f", group = "[F]ormat", icon = "󰗈" },
        { "<leader>p", group = "[P]recognition", icon = "󰬯" },
        { "<leader>?", group = "[?] Cheatsheet", icon = "󰧹" },
    },
    gitsigns = {
        {
            "<leader>gs",
            function()
                require("gitsigns").stage_hunk()
            end,
            desc = "[G]it [S]tage Hunk",
            mode = { "n", "v" },
        },
        {
            "<leader>gr",
            function()
                require("gitsigns").reset_hunk()
            end,
            desc = "[G]it [R]eset Hunk",
            mode = { "n", "v" },
        },
        {
            "<leader>gp",
            function()
                require("gitsigns").preview_hunk()
            end,
            desc = "[G]it [P]review Hunk",
            mode = "n",
        },
        {
            "<leader>gb",
            function()
                require("gitsigns").blame_line()
            end,
            desc = "[G]it [B]lame Line",
            mode = "n",
        },
        {
            "]c",
            function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    ---@diagnostic disable-next-line: param-type-mismatch
                    require("gitsigns").nav_hunk("next")
                end
            end,
            desc = "Next Hunk",
            mode = "n",
            expr = true,
        },
        {
            "[c",
            function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[c", bang = true })
                else
                    ---@diagnostic disable-next-line: param-type-mismatch
                    require("gitsigns").nav_hunk("prev")
                end
            end,
            desc = "Previous Hunk",
            mode = "n",
            expr = true,
        },
    },
    globals = {
        -- Window Navigation
        { "<A-h>", "<C-w>h", desc = "Window Left" },
        { "<A-j>", "<C-w>j", desc = "Window Down" },
        { "<A-k>", "<C-w>k", desc = "Window Up" },
        { "<A-l>", "<C-w>l", desc = "Window Right" },
        -- Window Resizing
        { "<A-=>", "<C-w>+", desc = "Resize Increase Height" },
        { "<A-->", "<C-w>-", desc = "Resize Decrease Height" },
        { "<A-.>", "<C-w>>", desc = "Resize Increase Width" },
        { "<A-,>", "<C-w><", desc = "Resize Decrease Width" },
        -- Splits
        { "<A-n>", "<C-w>s", desc = "Split Window Horizontal" },
        { "<A-;>", "<C-w>x", desc = "Swap Window" },
        { "<A-q>", ":q<CR>", desc = "Close Window" },
        -- Misc
        { "<Esc>", "<cmd>nohlsearch<CR>", desc = "Clear Highlight" },
        { "<leader>dd", vim.diagnostic.open_float, desc = "Show [D]iagnostics" },
    },
    harpoon = {
        {
            "<leader>ha",
            function()
                require("harpoon"):list():add()
            end,
            desc = "[H]arpoon [A]dd file",
            mode = "n",
        },
        {
            "<leader>hq",
            function()
                local harpoon = require("harpoon")
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            desc = "[H]arpoon [Q]uick menu",
            mode = "n",
        },
        {
            "<A-a>",
            function()
                require("harpoon"):list():select(1)
            end,
            desc = "Harpoon file 1",
            mode = "n",
        },
        {
            "<A-s>",
            function()
                require("harpoon"):list():select(2)
            end,
            desc = "Harpoon file 2",
            mode = "n",
        },
        {
            "<A-d>",
            function()
                require("harpoon"):list():select(3)
            end,
            desc = "Harpoon file 3",
            mode = "n",
        },
        {
            "<A-f>",
            function()
                require("harpoon"):list():select(4)
            end,
            desc = "Harpoon file 4",
            mode = "n",
        },
    },
    lazygit = {
        {
            "<leader>lg",
            function()
                vim.api.nvim_command("lua Snacks.lazygit()")
            end,
            desc = "[L]azy[G]it",
            mode = "n",
        },
        {
            "<leader>ll",
            function()
                vim.api.nvim_command("lua Snacks.lazygit.log()")
            end,
            desc = "[L]azyGit [L]og",
            mode = "n",
        },
        {
            "<leader>lf",
            function()
                vim.api.nvim_command("lua Snacks.lazygit.log_file()")
            end,
            desc = "[L]azyGit [F]ile Log",
            mode = "n",
        },
    },
    lsp = {
        { "K", vim.lsp.buf.hover, desc = "[K] Hover Documentation" },
        {
            "gd",
            function()
                require("telescope.builtin").lsp_definitions()
            end,
            desc = "[G]oto [D]efinition",
        },
        { "ge", vim.lsp.buf.declaration, desc = "[G]oto D[e]claration" },
        {
            "gi",
            function()
                require("telescope.builtin").lsp_implementations()
            end,
            desc = "[G]oto [I]mplementation",
        },
        {
            "gr",
            function()
                require("telescope.builtin").lsp_references()
            end,
            desc = "[G]oto [R]eferences",
        },
        {
            "gt",
            function()
                require("telescope.builtin").lsp_type_definitions()
            end,
            desc = "[G]oto [T]ype",
        },
        {
            "<leader>ss",
            function()
                require("telescope.builtin").lsp_document_symbols()
            end,
            desc = "[S]earch [S]ymbols",
        },
        {
            "<leader>ws",
            function()
                require("telescope.builtin").lsp_dynamic_workspace_symbols()
            end,
            desc = "[W]orkspace [S]ymbols",
        },
        { "<leader>r", vim.lsp.buf.rename, desc = "[R]ename" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "[C]ode [A]ction" },
        { "<leader>f", vim.lsp.buf.format, desc = "[F]ormat" },
        {
            "<leader>ci",
            function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end,
            desc = "[I]nlay Hints",
        },
    },
    neogen = {
        {
            "<leader>cd",
            ":lua require('neogen').generate()<CR>",
            desc = "[C]ode Add [D]ocumentation",
            mode = "n",
        },
    },
    neotree = {
        {
            "<leader>tt",
            function()
                vim.api.nvim_command("Neotree toggle")
            end,
            desc = "[T]ree [T]oggle",
            mode = "n",
        },
        {
            "<leader>ts",
            function()
                vim.api.nvim_command("Neotree show")
            end,
            desc = "[T]ree [S]how",
            mode = "n",
        },
        {
            "<leader>tc",
            function()
                vim.api.nvim_command("Neotree close")
            end,
            desc = "[T]ree [C]lose",
            mode = "n",
        },
        {
            "<leader>tf",
            function()
                vim.api.nvim_command("Neotree focus")
            end,
            desc = "[T]ree [F]ocus",
            mode = "n",
        },
        {
            "<leader>tg",
            function()
                vim.api.nvim_command("Neotree git_status")
            end,
            desc = "[T]ree [G]it Status",
            mode = "n",
        },
        {
            "<leader>tb",
            function()
                vim.api.nvim_command("Neotree buffers")
            end,
            desc = "[T]ree [B]uffers",
            mode = "n",
        },
    },
    oil = {
        { "<leader>te", vim.cmd.Oil, desc = "[T]ree [E]dit", mode = "n" },
    },
    overseer = {
        { "<leader>ob", vim.cmd.OverseerBuild, desc = "[O]verseer [B]uild", mode = "n" },
        { "<leader>oc", vim.cmd.OverseerRunCmd, desc = "[O]verseer Run [C]ommand", mode = "n" },
        { "<leader>or", vim.cmd.OverseerRun, desc = "[O]verseer [R]un", mode = "n" },
        { "<leader>ot", vim.cmd.OverseerToggle, desc = "[O]verseer [T]oggle", mode = "n" },
    },
    precognition = {
        {
            "<leader>p",
            function()
                if require("precognition").toggle() then
                    vim.notify("Precognition ON")
                else
                    vim.notify("Precognition OFF")
                end
            end,
            desc = "[P]recognition",
            mode = "n",
        },
    },
    ---@param telescope_builtin table
    telescope = function(telescope_builtin)
        return {
            {
                "<leader>sh",
                telescope_builtin.help_tags,
                desc = "[S]earch [H]elp",
                mode = "n",
            },
            {
                "<leader>sk",
                telescope_builtin.keymaps,
                desc = "[S]earch [K]eymaps",
                mode = "n",
            },
            {
                "<leader>sf",
                telescope_builtin.find_files,
                desc = "[S]earch [F]iles",
                mode = "n",
            },
            {
                "<leader>sb",
                telescope_builtin.find_files,
                desc = "[S]earch file [B]rowser",
                mode = "n",
            },
            {
                "<leader>ss",
                telescope_builtin.builtin,
                desc = "[S]earch [S]elect Telescope",
                mode = "n",
            },
            {
                "<leader>sw",
                telescope_builtin.grep_string,
                desc = "[S]earch current [W]ord",
                mode = "n",
            },
            {
                "<leader>sg",
                telescope_builtin.live_grep,
                desc = "[S]earch by [G]rep",
                mode = "n",
            },
            {
                "<leader>sd",
                telescope_builtin.diagnostics,
                desc = "[S]earch [D]iagnostics",
                mode = "n",
            },
            {
                "<leader>sr",
                telescope_builtin.resume,
                desc = "[S]earch [R]esume",
                mode = "n",
            },
            {
                "<leader>s.",
                telescope_builtin.oldfiles,
                desc = '[S]earch Recent Files ("." for repeat)',
                mode = "n",
            },
            {
                "<leader><leader>",
                telescope_builtin.buffers,
                desc = "[󰜞] Find existing buffers",
                mode = "n",
            },
            -- Slightly advanced example of overriding default behavior and theme
            {
                "<leader>/",
                function()
                    -- You can pass additional configuration to telescope to change theme, layout, etc.
                    telescope_builtin.current_buffer_fuzzy_find(
                        require("telescope.themes").get_dropdown({
                            winblend = 10,
                            previewer = false,
                        })
                    )
                end,
                desc = "[/] Fuzzily search in current buffer",
                mode = "n",
            },
            -- Also possible to pass additional configuration options.
            --  See `:help telescope.builtin.live_grep()` for information about particular keys
            {
                "<leader>s/",
                function()
                    telescope_builtin.live_grep({
                        grep_open_files = true,
                        prompt_title = "Live Grep in Open Files",
                    })
                end,
                desc = "[S]earch [/] in Open Files",
                mode = "n",
            },
            -- Shortcut for searching your neovim configuration files
            {
                "<leader>sn",
                function()
                    telescope_builtin.find_files({ cwd = vim.fn.stdpath("config") })
                end,
                desc = "[S]earch [N]eovim files",
                mode = "n",
            },
        }
    end,
    todo_comments = {
        {
            "]t",
            function()
                require("todo-comments").jump_next()
            end,
            desc = "Next Todo Comment",
        },
        {
            "[t",
            function()
                require("todo-comments").jump_prev()
            end,
            desc = "Previous Todo Comment",
        },
        { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo" },
        {
            "<leader>xT",
            "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
            desc = "Todo/Fix/Fixme",
        },
        { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
        {
            "<leader>sT",
            "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",
            desc = "Todo/Fix/Fixme",
        },
    },
    trouble = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
        {
            "<leader>xX",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics",
        },
        { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols" },
        {
            "<leader>cS",
            "<cmd>Trouble lsp toggle<cr>",
            desc = "LSP references/definitions/... (Trouble)",
        },
        { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
        { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
        {
            "[q",
            function()
                if require("trouble").is_open() then
                    require("trouble").prev({ skip_groups = true, jump = true })
                else
                    local ok, err = pcall(vim.cmd.cprev)
                    if not ok then
                        vim.notify(err, vim.log.levels.ERROR)
                    end
                end
            end,
            desc = "Previous Trouble/Quickfix Item",
        },
        {
            "]q",
            function()
                if require("trouble").is_open() then
                    require("trouble").next({ skip_groups = true, jump = true })
                else
                    local ok, err = pcall(vim.cmd.cnext)
                    if not ok then
                        if err then
                            vim.notify(err, vim.log.levels.ERROR)
                        else
                            vim.notify("An error occured but returned nil!", vim.log.levels.ERROR)
                        end
                    end
                end
            end,
            desc = "Next Trouble/Quickfix Item",
        },
    },
    rainbow_delimiters = {
        {
            "<leader>(",
            function()
                local rm_module = require("rainbow-delimiters")
                rm_module.toggle(0)
                if rm_module.is_enabled(0) then
                    vim.notify("Rainbow Delimiters: ON", vim.log.levels.INFO)
                else
                    vim.notify("Rainbow Delimiters: OFF", vim.log.levels.INFO)
                end
            end,
            desc = "Toggle Rainbow Delimiters",
        },
    },
    undotree = {
        { "U", vim.cmd.UndotreeToggle, desc = "[U]ndotree" },
    },
}
