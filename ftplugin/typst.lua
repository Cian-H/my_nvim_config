local lspconfig = require("lspconfig")

lspconfig.tinymist.setup({
    settings = {
        formatterMode = "typstyle",
        exportPdf = "onType",
        semanticTokens = "disable",
    },
})
