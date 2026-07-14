---@type Keymap[]
local keys = require("config.keys").globals

for _, map in ipairs(keys) do
    local opts = {
        noremap = true,
        silent = true,
        desc = map.desc,
    }
    for k, v in pairs(map) do
        if k ~= 1 and k ~= 2 and k ~= "desc" and k ~= "mode" then
            opts[k] = v
        end
    end
    vim.keymap.set(map.mode or "n", map[1], map[2], opts)
end
