return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            { "j-hui/fidget.nvim", opts = {} },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    local lsp_keys = require("config.keys").lsp
                    for _, map in ipairs(lsp_keys) do
                        vim.keymap.set("n", map[1], map[2], {
                            buffer = event.buf,
                            desc = "LSP: " .. map.desc
                        })
                    end

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ruff",
                    "pylsp",
                    "taplo",
                },
            })

            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                    },
                },
            })
        end,
    },
    { "fladson/vim-kitty",        ft = "kitty" },
    { "scallop-lang/vim-scallop", ft = "scallop" },
}
