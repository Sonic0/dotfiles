return {
    {
        "hedyhli/outline.nvim",
        lazy = true,
        cmd = { "Outline", "OutlineOpen" },
        keys = {
            { "<Leader>k", "<Cmd>Outline<CR>", desc = "Toggle code outline" },
        },
        opts = {}, -- use outline.nvim defaults
    },
}
