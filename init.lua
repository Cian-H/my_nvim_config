-- Enable experimental fast lua module loader
vim.loader.enable()

vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\\\"

require("config")

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

local hotpotpath = vim.fn.stdpath("data") .. "/lazy/hotpot.nvim"
if not vim.loop.fs_stat(hotpotpath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/rktjmp/hotpot.nvim.git",
        hotpotpath,
    })
end

---@diagnostic disable: undefined-field
vim.opt.rtp:prepend(hotpotpath)
vim.opt.rtp:prepend(lazypath)
---@diagnostic enable: undefined-field

require("hotpot")
require("keybindings")

require("lazy").setup("plugins")
require("nvim-web-devicons").refresh() -- This fixes screwiness with the devicon colors
