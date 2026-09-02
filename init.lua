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

local original_secure_read = vim.secure.read
vim.secure.read = function(path) ---@diagnostic disable-line: duplicate-set-field
    if path:match("%.hotpot%.fnl$") then
        -- Only auto-trust if it resides in the immutable Nix store or user config directory
        if path:match("^/nix/store/") or path:match("^/home/cianh/%.config/nvim/") then
            local file = io.open(path, "r")
            if file then
                local content = file:read("*a")
                file:close()
                return content
            end
        end
    end
    return original_secure_read(path)
end

require("hotpot").setup()
pcall(function()
    local ctx = require("hotpot.util").R.Context.new(vim.fn.stdpath("config"))
    require("hotpot.util").R.Context.sync(ctx)
end)
vim.loader.reset()

require("lazy").setup("plugins")

require("keybindings")
require("config.autocmds")
