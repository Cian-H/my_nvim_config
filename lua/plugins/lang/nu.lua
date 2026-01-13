return {
    require("neovim/nvim-lspconfig").nushell.setup({
        cmd = {
            "nu",
            "--config",
            vim.env.XDG_CONFIG_HOME .. "/nushell/lsp.nu",
            "--lsp",
        },
    }),
}
