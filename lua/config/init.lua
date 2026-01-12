-- First, i want to configure my vanilla nvim settings
vim.wo.number = true -- Line numbers
vim.wo.relativenumber = true
vim.opt.wrap = false
vim.opt.mouse = "a" -- enable mouse mode for window resizing
vim.opt.clipboard = "unnamedplus" -- share system and nvim clipboard
vim.g.have_nerd_font = true
vim.opt.undofile = true -- Save undo history
-- Add shell-specific settings
local shell_path = os.getenv("SHELL") or ""

if (vim.fn.executable("nu") == 1) and shell_path:find("nu") then
    vim.opt.sh = "nu"
    vim.opt.shelltemp = false
    vim.opt.shellredir = "out+err> %s"
    vim.opt.shellcmdflag = "--stdin --no-newline -c"
    vim.opt.shellxescape = ""
    vim.opt.shellxquote = ""
    vim.opt.shellquote = ""
    vim.opt.shellpipe =
        "| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record"
end
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
        pig = "pig",
        hive = "hive",
        hql = "hive",
    },
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
