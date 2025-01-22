-- Enable experimental fast lua module loader
vim.loader.enable()

require("config")
require("keybindings")

-- Then, i want to load lazy as my plugin manager and have it load my plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", opts)

-- Next, set up custom LSPs
local lspconfig = require("lspconfig")
lspconfig.nushell.setup({})
lspconfig.prolog_ls.setup({ root_dir = lspconfig.util.root_pattern(".git") })
lspconfig.nixd.setup({})
lspconfig.mojo.setup({})

require("nvim-web-devicons").refresh() -- This fixes screwiness with the devicon colors
