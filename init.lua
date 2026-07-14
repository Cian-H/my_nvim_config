-- Enable experimental fast lua module loader
vim.loader.enable()

vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\\\"

require("config")

local utils = require("config.utils")
local lazypath = utils.ensure_plugin("lazy.nvim", "folke/lazy.nvim", "stable")
local hotpotpath = utils.ensure_plugin("hotpot.nvim", "rktjmp/hotpot.nvim")

utils.clean_conflicting_parsers()

---@diagnostic disable: undefined-field
vim.opt.rtp:prepend(hotpotpath)
vim.opt.rtp:prepend(lazypath)
---@diagnostic enable: undefined-field

require("hotpot")
require("keybindings")
require("config.autocmds")

require("lazy").setup("plugins")
require("nvim-web-devicons").refresh() -- This fixes screwiness with the devicon colors
