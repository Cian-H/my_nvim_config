return { -- General programming utilities go here
    -- Tools for configuration and plugin development
    { "folke/neoconf.nvim", cmd = "Neoconf" },
    {
        "folke/neodev.nvim",
        opts = {
            override = function(root_dir, library)
                if
                    root_dir:find(
                        os.getenv("XDG_CONFIG_HOME")
                            .. "/nix/home-manager/core/dotfiles/dot_config/nvim/",
                        1,
                        true
                    ) == 1
                then
                    library.enabled = true
                    library.plugins = true
                end
            end,
        },
    },
    -- Privilege escalation plugin
    { "lambdalisue/suda.vim", event = "VeryLazy" },
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
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = require("config.keys").todo_comments,
    },
    "tpope/vim-fugitive", -- Also want to add fugitive, since it's apparently a great git plugin
    "jlfwong/vim-mercenary", -- Mercenary is the mercurial equivalent of fugitive
    { -- Oil is a very nice buffer-based filetree editor
        "stevearc/oil.nvim",
        event = "VeryLazy",
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = require("config.keys").oil,
    },
    { -- Harpoon, because i keep losing track of my markers
        "theprimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("harpoon"):setup({})
        end,
        keys = require("config.keys").harpoon,
    },
    -- Snippets
    "SirVer/ultisnips",
    "honza/vim-snippets",
    "rafamadriz/friendly-snippets",
    { -- Package and devenv plugins
        "danymat/neogen",
        event = "VimEnter",
        config = function()
            require("neogen").setup({
                enabled = true,
                snippet_engine = "luasnip",
                languages = {
                    python = {
                        template = {
                            annotation_convention = "google_docstrings",
                        },
                    },
                },
            })
        end,
        keys = require("config.keys").neogen,
    },
    { -- Autoformat
        "stevearc/conform.nvim",
        event = "VimEnter",
        opts = {
            notify_on_error = false,
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                lua = { "stylua" },
                nix = { "alejandra" },
                -- Conform can also run multiple formatters sequentially
                -- python = { "isort", "black" },
                --
                -- You can use a sub-list to tell conform to run *until* a formatter
                -- is found.
                -- javascript = { { "prettierd", "prettier" } },
            },
        },
    },
    { -- Autocompletion
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    -- Build Step is needed for regex support in snippets
                    -- This step is not supported in many windows environments
                    -- Remove the below condition to re-enable on windows
                    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
            },
            "saadparwaiz1/cmp_luasnip",

            -- Adds other completion capabilities.
            --  nvim-cmp does not ship with all sources by default. They are split
            --  into multiple repos for maintenance purposes.
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",

            -- If you want to add a bunch of pre-configured snippets,
            --    you can use this plugin to help you. It even has snippets
            --    for various frameworks/libraries/etc. but you will have to
            --    set up the ones that are useful for you.
            -- 'rafamadriz/friendly-snippets',
        },
        config = function()
            -- See `:help cmp`
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            luasnip.config.setup({})

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = "menu,menuone,noinsert" },

                -- For an understanding of why these mappings were
                -- chosen, you will need to read `:help ins-completion`
                --
                -- No, but seriously. Please read `:help ins-completion`, it is really good!
                mapping = cmp.mapping.preset.insert({
                    -- Select the [n]ext item
                    ["<M-n>"] = cmp.mapping.select_next_item(),
                    -- Select the [p]revious item
                    ["<M-p>"] = cmp.mapping.select_prev_item(),

                    -- Accept ([y]es) the completion.
                    --  This will auto-import if your LSP supports it.
                    --  This will expand snippets if the LSP sent a snippet.
                    ["<M-y>"] = cmp.mapping.confirm({ select = true }),

                    -- Manually trigger a completion from nvim-cmp.
                    --  Generally you don't need this, because nvim-cmp will display
                    --  completions whenever it has completion options available.
                    ["<M-Space>"] = cmp.mapping.complete({}),

                    -- Think of <c-l> as moving to the right of your snippet expansion.
                    --  So if you have a snippet that's like:
                    --  function $name($args)
                    --    $body
                    --  end
                    --
                    -- <c-,> will move you to the right of each of the expansion locations.
                    -- <c-.> is similar, except moving you backwards.
                    ["<M-,>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<M-.>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                },
            })
        end,
    },
    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "bash", "c", "html", "lua", "markdown", "vim", "vimdoc" },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        },
        config = function(_, opts)
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup(opts)
        end,
        dependencies = {
            { "nushell/tree-sitter-nu", build = ":TSUpdate nu" },
        },
    },
    { -- Undo tree
        "mbbill/undotree",
        event = "VeryLazy",
        opts = {},
        config = function()
            vim.keymap.set("n", "U", vim.cmd.UndotreeToggle, { desc = "[U]ndotree" })
        end,
    },
    { -- Add Overseer as a task running tool
        "stevearc/overseer.nvim",
        event = "VeryLazy",
        opts = {},
        config = function()
            require("overseer").setup()
        end,
        keys = require("config.keys").overseer,
    },
    { -- A plugin to integrate tests is helpful, so i'm adding neotest
        "nvim-neotest/neotest",
        event = "VeryLazy",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },
    -- Rust tools like inlay hints are absolutely essential
    { "simrat39/rust-tools.nvim", ft = "rust" },
}
