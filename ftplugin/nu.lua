local lspconfig = require("lspconfig")
local config_path = (vim.env.XDG_CONFIG_HOME or vim.fn.expand("~/.config")) .. "/nushell/lsp.nu"

lspconfig.nushell.setup({
    cmd = { "nu", "--config", config_path, "--lsp" },
    root_dir = lspconfig.util.root_pattern("env.nu", "config.nu", ".git"),
})
