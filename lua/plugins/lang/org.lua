return {
    {
        "nvim-orgmode/orgmode",
        event = "VeryLazy",
        config = function()
            -- Setup orgmode
            require("orgmode").setup({
                org_agenda_files = "~/orgfiles/**/*",
                org_default_notes_file = "~/orgfiles/refile.org",
                mappings = {
                    prefix = "<leader>a",
                },
            })
            -- Enable org LSP
            vim.lsp.enable("org")
        end,
    },
}
