return {
    {
        "folke/trouble.nvim",
        cmd = { "Trouble" },
        keys = {
            {
                "<Leader>s",
                "<Cmd>Trouble diagnostics toggle<CR>",
                desc = "Toggle workspace diagnostics (Trouble)",
            },
            {
                "<Leader>sd",
                "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>",
                desc = "Toggle buffer diagnostics (Trouble)",
            },
        },
        opts = {}, -- use trouble.nvim v3 defaults
    },
}
