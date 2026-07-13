return {
    {
        "julienvincent/nvim-paredit",
        ft = { "clojure", "fennel", "scheme", "lisp", "janet", "racket", "hy", "elisp" },
        config = function()
            require("nvim-paredit").setup({
                filetypes = {
                    "clojure",
                    "fennel",
                    "scheme",
                    "lisp",
                    "janet",
                    "racket",
                    "hy",
                    "elisp",
                },
            })
        end,
    },
}
