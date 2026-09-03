;; Declare vim as a known global for fennel-ls linting
(local vim _G.vim)

;; Helper functions for keybindings

(fn gitsigns-nav [chord dir]
  (if vim.wo.diff
      (vim.cmd.normal {1 chord :bang true})
      (let [gs (require :gitsigns)]
        (gs.nav_hunk dir))))

(fn trouble-nav [dir fallback-cmd]
  (let [tr (require :trouble)]
    (if (tr.is_open)
        ((. tr dir) {:skip_groups true :jump true})
        (let [(ok err) (pcall vim.cmd fallback-cmd)]
          (when (not ok)
            (vim.notify err vim.log.levels.ERROR))))))

(fn toggle-lisp-tooling []
  (let [rm (require :rainbow-delimiters)]
    (rm.toggle 0)
    (let [active (rm.is_enabled 0)
          buf (vim.api.nvim_get_current_buf)
          lisp-fts [:clojure :fennel :scheme :lisp :janet :racket :hy :elisp]
          filetype (vim.api.nvim_get_option_value :filetype {: buf})]
      (if (vim.tbl_contains lisp-fts filetype)
          (let [(has-paredit paredit-config) (pcall require
                                                    :nvim-paredit.config)]
            (if has-paredit
                (let [keys paredit-config.config.keys]
                  (if active
                      (let [(has-kb keybindings) (pcall require
                                                        :nvim-paredit.utils.keybindings)]
                        (if has-kb
                            (keybindings.setup_keybindings {: keys : buf})))
                      (each [keymap action (pairs keys)]
                        (when action
                          (let [mode (or action.mode [:n :x])
                                modes (if (= (type mode) :string) [mode] mode)]
                            (each [_ m (ipairs modes)]
                              (pcall vim.keymap.del m keymap {:buffer buf})))))))
                (vim.notify (.. "Lisp Tooling: " (if active :ON :OFF))
                            vim.log.levels.INFO))
            (vim.notify (.. "Rainbow Delimiters: " (if active :ON :OFF))
                        vim.log.levels.INFO))))))

;; Define the keybindings prefix trie
(local trie
       {;; Globals (No leader)
        :<A-h> [:<C-w>h "Window Left" :globals]
        :<A-j> [:<C-w>j "Window Down" :globals]
        :<A-k> [:<C-w>k "Window Up" :globals]
        :<A-l> [:<C-w>l "Window Right" :globals]
        :<A-=> [:<C-w>+ "Resize Increase Height" :globals]
        :<A--> [:<C-w>- "Resize Decrease Height" :globals]
        :<A-.> [:<C-w>> "Resize Increase Width" :globals]
        "<A-,>" [:<C-w>< "Resize Decrease Width" :globals]
        :<A-n> [:<C-w>s "Split Window Horizontal" :globals]
        "<A-;>" [:<C-w>x "Swap Window" :globals]
        :<A-q> [":q<CR>" "Close Window" :globals]
        :<Esc> [:<cmd>nohlsearch<CR> "Clear Highlight" :globals]
        ;; Atone
        :U [#(let [atone (require :atone.core)] (atone.toggle))
            "[U]ndotree"
            :atone]
        ;; Gitsigns (no-leader)
        "]c" [#(gitsigns-nav "]c" :next)
              "Next Hunk"
              :gitsigns
              {:expr true :mode :n}]
        "[c" [#(gitsigns-nav "[c" :prev)
              "Previous Hunk"
              :gitsigns
              {:expr true :mode :n}]
        ;; LSP (no-leader)
        :K [#(vim.lsp.buf.hover) "[K] Hover Documentation" :lsp]
        :gd [#(let [s (require :snacks)] (s.picker.lsp_definitions))
             "[G]oto [D]efinition"
             :lsp]
        :ge [#(vim.lsp.buf.declaration) "[G]oto D[e]claration" :lsp]
        :gi [#(let [s (require :snacks)] (s.picker.lsp_implementations))
             "[G]oto [I]mplementation"
             :lsp]
        :gr [#(let [s (require :snacks)] (s.picker.lsp_references))
             "[G]oto [R]eferences"
             :lsp]
        :gt [#(let [s (require :snacks)] (s.picker.lsp_type_definitions))
             "[G]oto [T]ype"
             :lsp]
        ;; Todo comments (no-leader)
        "]t" [#(let [tc (require :todo-comments)] (tc.jump_next))
              "Next Todo Comment"
              :todo_comments]
        "[t" [#(let [tc (require :todo-comments)] (tc.jump_prev))
              "Previous Todo Comment"
              :todo_comments]
        ;; Trouble (no-leader)
        "[q" [#(trouble-nav :prev :cprev)
              "Previous Trouble/Quickfix Item"
              :trouble]
        "]q" [#(trouble-nav :next :cnext)
              "Next Trouble/Quickfix Item"
              :trouble]
        ;; Word references (snacks.words)
        "]w" [#(let [s (require :snacks)] (s.words.jump 1 true))
              "Next Reference"
              :snacks]
        "[w" [#(let [s (require :snacks)] (s.words.jump -1 true))
              "Previous Reference"
              :snacks]
        ;; Leader mappings
        :<leader> {:name :Leader
                   ;; Agenda / Org Mode Group
                   :a {:name "[A]genda" :icon "󰕪"}
                   ;; Search Group
                   :s {:name "[S]earch"
                       :icon ""
                       :h [#(let [s (require :snacks)] (s.picker.help))
                           "[S]earch [H]elp"
                           :snacks]
                       :k [#(let [s (require :snacks)] (s.picker.keymaps))
                           "[S]earch [K]eymaps"
                           :snacks]
                       :f [#(let [s (require :snacks)] (s.picker.files))
                           "[S]earch [F]iles"
                           :snacks]
                       :b [#(let [s (require :snacks)] (s.picker.buffers))
                           "[S]earch [B]uffers"
                           :snacks]
                       :s [#(let [s (require :snacks)] (s.picker.pickers))
                           "[S]earch [S]elect Picker"
                           :snacks]
                       :w [#(let [s (require :snacks)]
                              (s.picker.grep_word))
                           "[S]earch current [W]ord"
                           :snacks]
                       :g [#(let [s (require :snacks)] (s.picker.grep))
                           "[S]earch by [G]rep"
                           :snacks]
                       :d [#(let [s (require :snacks)]
                              (s.picker.diagnostics))
                           "[S]earch [D]iagnostics"
                           :snacks]
                       :r [#(let [s (require :snacks)] (s.picker.resume))
                           "[S]earch [R]esume"
                           :snacks]
                       :. [#(let [s (require :snacks)] (s.picker.recent))
                           "[S]earch Recent Files (\".\" for repeat)"
                           :snacks]
                       :/ [#(let [s (require :snacks)]
                              (s.picker.grep {:filter {:buf true}
                                              :title "Live Grep in Open Files"}))
                           "[S]earch [/] in Open Files"
                           :snacks]
                       :n [#(let [s (require :snacks)]
                              (s.picker.files {:cwd (vim.fn.stdpath :config)}))
                           "[S]earch [N]eovim files"
                           :snacks]
                       :N [#(let [s (require :snacks)]
                              (s.notifier.show_history))
                           "[S]earch [N]otification History"
                           :snacks]
                       :t [#(let [s (require :snacks)]
                              (s.picker.todo_comments))
                           :Todo
                           :todo_comments]
                       :T [#(let [s (require :snacks)]
                              (s.picker.todo_comments {:keywords [:TODO
                                                                  :FIX
                                                                  :FIXME]}))
                           :Todo/Fix/Fixme
                           :todo_comments]
                       :S [#(let [s (require :snacks)] (s.scratch.select))
                           "[S]earch [S]cratchpads"
                           :snacks]}
                   ;; Search buffer
                   :/ [#(let [s (require :snacks)] (s.picker.lines))
                       "[/] Fuzzily search in current buffer"
                       :snacks]
                   ;; Scratchpad
                   :. [#(let [s (require :snacks)] (s.scratch))
                       "Toggle Scratchpad"
                       :snacks]
                   ;; Notes / Scratchpad Group
                   :n {:name "[N]otes / Scratch"
                       :icon "󱞁"
                       :s [#(let [s (require :snacks)] (s.scratch))
                           "[S]cratchpad Toggle"
                           :snacks]
                       :S [#(let [s (require :snacks)] (s.scratch.select))
                           "[S]elect Scratchpad"
                           :snacks]}
                   ;; Code Group
                   :c {:name "[C]ode"
                       :icon ""
                       :s [#(let [s (require :snacks)]
                              (s.picker.lsp_symbols))
                           "[C]ode [S]ymbols"
                           :lsp]
                       :w [#(let [s (require :snacks)]
                              (s.picker.lsp_workspace_symbols))
                           "[C]ode [W]orkspace Symbols"
                           :lsp]
                       :d [":lua require('neogen').generate()<CR>"
                           "[C]ode Add [D]ocumentation"
                           :neogen]
                       :i [#(vim.lsp.inlay_hint.enable (not (vim.lsp.inlay_hint.is_enabled)))
                           "[I]nlay Hints"
                           :lsp]
                       :a [#(vim.lsp.buf.code_action) "[C]ode [A]ction" :lsp]}
                   ;; Rename (leaf, not group)
                   :r [#(vim.lsp.buf.rename) "[R]ename" :lsp]
                   ;; Format (leaf, not group)
                   :f [#(let [c (require :conform)]
                          (c.format {:async true :lsp_fallback true}))
                       "[F]ormat Document"
                       :conform]
                   ;; Diagnostics Group
                   :d {:name "[D]iagnostics"
                       :icon ""
                       :d [#(vim.diagnostic.open_float)
                           "Show [D]iagnostics"
                           :globals]
                       :n [#(let [s (require :snacks)] (s.notifier.hide))
                           "Dismiss [N]otifications"
                           :snacks]}
                   ;; Git Group
                   :g {:name "[G]it"
                       :icon "󰊢"
                       :s [#(let [gs (require :gitsigns)] (gs.stage_hunk))
                           "[G]it [S]tage Hunk"
                           :gitsigns
                           {:mode [:n :v]}]
                       :r [#(let [gs (require :gitsigns)] (gs.reset_hunk))
                           "[G]it [R]eset Hunk"
                           :gitsigns
                           {:mode [:n :v]}]
                       :p [#(let [gs (require :gitsigns)]
                              (gs.preview_hunk))
                           "[G]it [P]review Hunk"
                           :gitsigns
                           {:mode :n}]
                       :b [#(let [gs (require :gitsigns)] (gs.blame_line))
                           "[G]it [B]lame Line"
                           :gitsigns
                           {:mode :n}]
                       :c [#(let [s (require :snacks)] (s.picker.git_commits))
                           "[G]it [C]ommits"
                           :snacks]
                       :B [#(let [s (require :snacks)] (s.picker.git_branches))
                           "[G]it [B]ranches"
                           :snacks]
                       :S [#(let [s (require :snacks)] (s.picker.git_status))
                           "[G]it [S]tatus (Picker)"
                           :snacks]
                       :o [#(let [s (require :snacks)] (s.gitbrowse))
                           "[G]it [O]pen in Browser"
                           :snacks
                           {:mode [:n :v]}]
                       :y [#(let [s (require :snacks)]
                              (s.gitbrowse {:open (fn [url]
                                                    (vim.fn.setreg "+" url)
                                                    (vim.notify (.. "Copied Git URL: "
                                                                    url)
                                                                vim.log.levels.INFO
                                                                {:title "Git Browse"}))}))
                           "[G]it [Y]ank Permalink"
                           :snacks
                           {:mode [:n :v]}]}
                   ;; Tree Group — backed by snacks.explorer and oil
                   :t {:name "[T]ree"
                       :icon "󱏒"
                       :t [#(let [s (require :snacks)] (s.explorer))
                           "[T]ree [T]oggle"
                           :snacks]
                       :e [#(vim.cmd.Oil) "[T]ree [E]dit" :oil]}
                   ;; LazyGit Group
                   :l {:name "[L]azyGit"
                       :icon "󰒲"
                       :g [#(let [s (require :snacks)] (s.lazygit))
                           "[L]azy[G]it"
                           :snacks]
                       :l [#(let [s (require :snacks)] (s.lazygit.log))
                           "[L]azyGit [L]og"
                           :snacks]
                       :f [#(let [s (require :snacks)]
                              (s.lazygit.log_file))
                           "[L]azyGit [F]ile Log"
                           :snacks]}
                   ;; Overseer Group
                   :o {:name "[O]verseer"
                       :icon "󰈈"
                       :b [#(vim.cmd.OverseerBuild)
                           "[O]verseer [B]uild"
                           :overseer]
                       :c [#(vim.cmd.OverseerRunCmd)
                           "[O]verseer Run [C]ommand"
                           :overseer]
                       :r [#(vim.cmd.OverseerRun) "[O]verseer [R]un" :overseer]
                       :t [#(vim.cmd.OverseerToggle)
                           "[O]verseer [T]oggle"
                           :overseer]}
                   ;; Trouble Group
                   :x {:name "[X] Trouble"
                       :icon "󰋔"
                       :t ["<cmd>Trouble todo toggle<cr>" :Todo :todo_comments]
                       :T ["<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>"
                           :Todo/Fix/Fixme
                           :todo_comments]
                       :x ["<cmd>Trouble diagnostics toggle<cr>"
                           :Diagnostics
                           :trouble]
                       :X ["<cmd>Trouble diagnostics toggle filter.buf=0<cr>"
                           "Buffer Diagnostics"
                           :trouble]
                       :s ["<cmd>Trouble symbols toggle<cr>"
                           "Symbols (Trouble)"
                           :trouble]
                       :S ["<cmd>Trouble lsp toggle<cr>"
                           "LSP references/definitions/... (Trouble)"
                           :trouble]
                       :L ["<cmd>Trouble loclist toggle<cr>"
                           "Location List"
                           :trouble]
                       :Q ["<cmd>Trouble qflist toggle<cr>"
                           "Quickfix List"
                           :trouble]}
                   ;; Rainbow Delimiters / Lisp tooling
                   "(" [#(toggle-lisp-tooling)
                        "Toggle Lisp Tooling (Rainbow & Paredit)"
                        :rainbow_delimiters]
                   ;; Test Group (neotest)
                   :T {:name "[T]est"
                       :icon "󰙨"
                       :r [#(let [nt (require :neotest)] (nt.run.run))
                           "[T]est [R]un Nearest"
                           :neotest]
                       :f [#(let [nt (require :neotest)]
                              (nt.run.run (vim.fn.expand "%")))
                           "[T]est Run [F]ile"
                           :neotest]
                       :s [#(let [nt (require :neotest)] (nt.summary.toggle))
                           "[T]est Toggle [S]ummary"
                           :neotest]
                       :o [#(let [nt (require :neotest)]
                              (nt.output_panel.toggle))
                           "[T]est Toggle [O]utput"
                           :neotest]
                       :S [#(let [nt (require :neotest)] (nt.run.stop))
                           "[T]est [S]top"
                           :neotest]}
                   ;; UI / Toggles Group
                   :u {:name "[U]I / Toggles"
                       :icon "󰔡"
                       :i [#(let [s (require :snacks)]
                              (: (s.toggle.inlay_hints) :toggle))
                           "Toggle [I]nlay Hints"
                           :snacks]
                       :d [#(let [s (require :snacks)]
                              (: (s.toggle.diagnostics) :toggle))
                           "Toggle [D]iagnostics"
                           :snacks]
                       :w [#(let [s (require :snacks)]
                              (: (s.toggle.option :wrap {:name "Line Wrap"})
                                 :toggle))
                           "Toggle Line [W]rap"
                           :snacks]
                       :l [#(let [s (require :snacks)]
                              (: (s.toggle.line_number) :toggle))
                           "Toggle [L]ine Numbers"
                           :snacks]
                       :s [#(let [s (require :snacks)]
                              (: (s.toggle.option :spell {:name :Spelling})
                                 :toggle))
                           "Toggle [S]pell Check"
                           :snacks]}
                   ;; Yank / Path Group
                   :y {:name "[Y]ank / Path"
                       :icon "󰅍"
                       :p [#(let [path (vim.fn.expand "%:~:.")]
                              (vim.fn.setreg "+" path)
                              (vim.notify (.. "Copied relative path: " path)
                                          vim.log.levels.INFO
                                          {:title "Yank Path"}))
                           "[Y]ank Relative [P]ath"
                           :globals]
                       :l [#(let [path (.. (vim.fn.expand "%:~:.") ":"
                                           (vim.fn.line "."))]
                              (vim.fn.setreg "+" path)
                              (vim.notify (.. "Copied path with line: " path)
                                          vim.log.levels.INFO
                                          {:title "Yank Path"}))
                           "[Y]ank Path with [L]ine"
                           :globals]
                       :a [#(let [path (vim.fn.expand "%:p")]
                              (vim.fn.setreg "+" path)
                              (vim.notify (.. "Copied absolute path: " path)
                                          vim.log.levels.INFO
                                          {:title "Yank Path"}))
                           "[Y]ank [A]bsolute Path"
                           :globals]}}
        ;; Local Leader
        :<localleader> {:name "[L]ocal Leader (\\\\)"
                        :icon "󰌌"
                        ;; Conjure (Lisp REPL) submenus
                        :c {:name "[C]onnect" :icon "󰌘"}
                        :e {:name "[E]val"
                            :icon "󰅩"
                            :c {:name "[C]omment" :icon "󰅺"}}
                        :g {:name "[G]et / Doc" :icon "󰈙"}
                        :l {:name "[L]og" :icon "󱂅"}
                        :r {:name "[R]eset / REPL" :icon "󰦛"}
                        :s {:name "[S]ession" :icon "󱥸"}
                        :t {:name "[T]est" :icon "󰙨"}
                        :v {:name "[V]iew" :icon "󰈈"}
                        ;; Local UV
                        :x {:name "Local [X] UV" :icon "󰌠"}}})

;; Flatten/parse the prefix trie into the flat representation for Neovim config
(local M {:groups []})

(fn traverse [node prefix]
  (if (= (type node) :table)
      (if (. node 1)
          ;; Leaf node: [rhs description plugin-name opts]
          (let [[rhs desc ?plugin ?opts] node
                plugin (or ?plugin :globals)
                opts (or ?opts {})
                entry (collect [k v (pairs opts)] (values k v))]
            (tset entry 1 prefix)
            (tset entry 2 rhs)
            (set entry.desc desc)
            ;; Ensure the list for this plugin exists
            (when (not (. M plugin))
              (tset M plugin []))
            (table.insert (. M plugin) entry))
          ;; Branch node
          (do
            ;; Check if it has group metadata
            (when (and node.name (not= prefix ""))
              (let [group-entry {1 prefix :group node.name}]
                (when node.icon
                  (set group-entry.icon node.icon))
                (table.insert M.groups group-entry)))
            ;; Recursively traverse children
            (each [k v (pairs node)]
              (when (and (not= k :name) (not= k :icon))
                (traverse v (.. prefix k))))))))

;; Execute the traversal on the top-level trie
(traverse trie "")

M
