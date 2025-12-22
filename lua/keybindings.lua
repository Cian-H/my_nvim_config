local keys = require("config.keys").globals

for _, map in ipairs(keys) do
    vim.keymap.set("n", map[1], map[2], {
        noremap = true,
        silent = true,
        desc = map.desc,
    })
end
