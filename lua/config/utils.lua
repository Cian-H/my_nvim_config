local M = {}

-- Helper function to ensure core bootstrapping plugins are installed
function M.ensure_plugin(name, repo, branch)
    local path = vim.fn.stdpath("data") .. "/lazy/" .. name
    if not (vim.uv or vim.loop).fs_stat(path) then
        local cmd = {
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/" .. repo .. ".git",
        }
        if branch then
            table.insert(cmd, "--branch=" .. branch)
        end
        table.insert(cmd, path)
        vim.fn.system(cmd)
    end
    return path
end

return M
