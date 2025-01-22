-- First, i want to configure my vanilla nvim settings
vim.wo.number = true -- Line numbers
vim.wo.relativenumber = true
vim.opt.wrap = false
vim.opt.mouse = "a" -- enable mouse mode for window resizing
vim.opt.clipboard = "unnamedplus" -- share system and nvim clipboard
vim.g.have_nerd_font = true
vim.opt.undofile = true -- Save undo history
-- Add custom commentstring definitions
vim.api.nvim_create_autocmd("FileType", {
    pattern = "nix,flake",
    command = "setlocal commentstring=#\\ %s",
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "scallop",
    command = "setlocal commentstring=//%s",
})
-- Add custom file types
vim.filetype.add({
    extension = {
        scl = "scallop",
        prolog = "prolog",
        pro = "prolog",
        nu = "nu",
        mojo = "mojo",
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.completionProvider then
            vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
        end
        if client.server_capabilities.definitionProvider then
            vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
        end
    end,
})

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes" -- Keep signcolumn on by default
-- Decrease update time and timeout between key commands
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
-- Render markers so we don't mistakenly put tabs (and other whitespace) where we dont want them
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
-- Also, while we're at it: let's set the tab widths
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.inccommand = "split" -- Preview substitutions live, as you type!
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.scrolloff = 4 -- Minimal number of screen lines to keep above and below the cursor.
-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Diagnostics config
vim.diagnostic.config({
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = false,
})
