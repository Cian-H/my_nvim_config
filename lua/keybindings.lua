vim.keymap.set("n", "<A-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<A-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<A-l>", "<C-w>l", { noremap = true, silent = true })
vim.keymap.set("n", "<A-Left>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<A-Down>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<A-Up>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<A-Right>", "<C-w>l", { noremap = true, silent = true })
vim.keymap.set("n", "<A-=>", "<C-w>+", { noremap = true, silent = true })
vim.keymap.set("n", "<A-->", "<C-w>-", { noremap = true, silent = true })
vim.keymap.set("n", "<A-.>", "<C-w>>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-,>", "<C-w><", { noremap = true, silent = true })
vim.keymap.set("n", "<A-n>", "<C-w>s", { noremap = true, silent = true })
-- This keymap isn't ideal but its the best i can figure out right now
vim.keymap.set("n", "<A-;>", "<C-w>x", { noremap = true, silent = true })
vim.keymap.set("n", "<A-q>", ":q<CR>", { noremap = true, silent = true })
-- Non standard key mappings are here
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "[D]iagnostics" })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "[F]ormat" })
vim.keymap.set(
    "n",
    "<leader>ci",
    function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end,
    { desc = "[I]nlay Hints" }
)
