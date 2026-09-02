;; Declare vim as a known global for fennel-ls linting
(local vim _G.vim)

;; Neovim autocommands and runtime logic in Fennel

;; Highlight on yank
(vim.api.nvim_create_autocmd :TextYankPost
                             {:desc "Highlight when yanking (copying) text"
                              :group (vim.api.nvim_create_augroup :kickstart-highlight-yank
                                                                  {:clear true})
                              :callback #(vim.highlight.on_yank)})

;; FileType custom commentstrings
(vim.api.nvim_create_autocmd :FileType
                             {:pattern [:nix :flake]
                              :callback #(set vim.bo.commentstring "# %s")})

(vim.api.nvim_create_autocmd :FileType
                             {:pattern [:scallop]
                              :callback #(set vim.bo.commentstring "//%s")})

;; Root changer on VimEnter (Custom pipeline logic)
(vim.api.nvim_create_autocmd :VimEnter
                             {:desc "Change CWD to project root if inside git repo"
                              :callback (fn []
                                          (let [current-file (vim.fn.expand "%:p")]
                                            (when (not= current-file "")
                                              (let [find-results (vim.fs.find [:.git]
                                                                              {:upward true
                                                                               :path (vim.fs.dirname current-file)})
                                                    git-dir (. find-results 1)]
                                                (when git-dir
                                                  (let [root-dir (vim.fs.dirname git-dir)]
                                                    (vim.cmd.cd root-dir)
                                                    (print (.. "Root changed to: "
                                                               root-dir))))))))})
