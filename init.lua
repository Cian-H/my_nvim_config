vim.loader.enable() -- Enable experimental fast lua module loader

vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\\\"

local utils = require("config.utils")
local lazypath = utils.ensure_plugin("lazy.nvim", "folke/lazy.nvim", "stable")
local hotpotpath = utils.ensure_plugin("hotpot.nvim", "rktjmp/hotpot.nvim", "main")

utils.clean_conflicting_parsers()

vim.opt.rtp:prepend({ hotpotpath, lazypath }) ---@diagnostic disable-line: undefined-field

require("hotpot").setup()

require("config")
require("keybindings")
require("config.autocmds")

local hotpotcontext = assert(require("hotpot.api").context(vim.fn.stdpath("config")))

require("lazy").setup({
    spec = {
        { import = "plugins" },
        { "rktjmp/hotpot.nvim", version = "^2.0.0" },
    },
    performance = {
        rtp = {
            paths = { hotpotcontext.locate("destination") },
        },
    },
})

require("nvim-web-devicons").refresh() -- This fixes screwiness with the devicon colors
