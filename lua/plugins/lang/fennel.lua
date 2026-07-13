return {
    {
        "rktjmp/hotpot.nvim",
        lazy = false,
    },
    {
        "Olical/conjure",
        ft = { "fennel", "clojure", "scheme", "lisp" },
        config = function()
            -- Conjure configuration
            -- By default, Conjure maps local leader commands (e.g. <localleader>ee to evaluate form).
        end,
    },
}
