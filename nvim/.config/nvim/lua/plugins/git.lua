return {
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "Gread", "Gdiff", "Gvdiffsplit" },
        keys = {
            { "<Leader>gg", ":Git<CR>",                        desc = "Git status (fugitive)" },
            { "<Leader>gc", ":Git commit<CR>",                 desc = "Git commit" },
            { "<Leader>gm", ":Git mergetool | Gvdiffsplit!<CR>", desc = "Git three-way merge" },
        },
    },

    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = function(_, opts)
            -- Merge our extra keymaps into LazyVim's gitsigns opts.
            opts.on_attach = function(bufnr)
                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                map("n", "<Leader>ga", ":Gitsigns stage_hunk<CR>",    "Git add hunk")
                map("n", "<Leader>gu", ":Gitsigns undo_stage_hunk<CR>", "Git unstage hunk")
                map("n", "<Leader>gA", ":Gitsigns stage_buffer<CR>",  "Git add file")
                map("n", "<Leader>gU", ":Gitsigns reset_buffer<CR>",  "Git reset file")
                map("n", "<Leader>gd", ":Gitsigns diffthis<CR>",      "Git diff")
                map("n", "<Leader>gb", ":Gitsigns blame_line<CR>",    "Git blame line")
            end
        end,
    },
}
