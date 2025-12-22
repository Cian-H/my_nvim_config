return {
    {
        "benomahony/uv.nvim",
        ft = { "python" },
        dependencies = {
            "folke/snacks.nvim",
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            picker_integration = true,
        },
    },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                python = { "ruff" },
            },
        },
    },
}
