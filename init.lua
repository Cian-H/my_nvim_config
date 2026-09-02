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
        local config_dir = vim.fn.stdpath("config")
        local real_config = vim.uv.fs_realpath(config_dir) or config_dir
        local real_path = vim.uv.fs_realpath(path) or path
        -- Auto-trust if inside nix store, or inside neovim config directory (direct or symlinked)
        if
            path:match("^/nix/store/")
            or real_path:match("^/nix/store/")
            or vim.fs.relpath(config_dir, path)
            or vim.fs.relpath(real_config, real_path)
        then
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

require("hotpot")

local hotpot_dest = require("hotpot.util").R.const.HOTPOT_CONFIG_CACHE_ROOT

-- Only sync if compiled cache is missing or stale, avoiding expensive full-tree scans on boot
local function needs_hotpot_sync()
    local config_dir = vim.fn.stdpath("config")
    local fnl_dir = vim.fs.joinpath(config_dir, "fnl")
    if not vim.uv.fs_stat(fnl_dir) then
        return false
    end
    local fnl_files = vim.fs.find(function(name)
        return name:match("%.fnlm?$") ~= nil
    end, { path = fnl_dir, type = "file", limit = math.huge })
    for _, fnl_path in ipairs(fnl_files) do
        local rel = vim.fs.relpath(config_dir, fnl_path)
        if rel then
            local lua_rel = rel:gsub("^fnl/", "lua/"):gsub("%.fnlm?$", ".lua")
            local lua_path = vim.fs.joinpath(hotpot_dest, lua_rel)
            local fnl_stat = vim.uv.fs_stat(fnl_path)
            local lua_stat = vim.uv.fs_stat(lua_path)
            if fnl_stat and (not lua_stat or fnl_stat.mtime.sec > lua_stat.mtime.sec) then
                return true
            end
        end
    end
    return false
end

if needs_hotpot_sync() then
    pcall(function()
        local ctx = require("hotpot.util").R.Context.new(vim.fn.stdpath("config"))
        require("hotpot.util").R.Context.sync(ctx)
    end)
    vim.loader.reset()
end

local rtp_paths = { hotpotpath }
if hotpot_dest then
    table.insert(rtp_paths, hotpot_dest)
end

require("lazy").setup("plugins", {
    performance = {
        rtp = {
            paths = rtp_paths,
        },
    },
})

require("keybindings")
require("config.autocmds")
