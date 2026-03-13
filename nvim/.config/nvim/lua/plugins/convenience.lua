return {
    -- Automatically detect and set indent settings from the file
    { "tpope/vim-sleuth", event = "VeryLazy" },

    -- Surround motions (ys, cs, ds)
    { "kylechui/nvim-surround", event = "VeryLazy", config = true },

    -- Make plugin commands repeatable with .
    { "tpope/vim-repeat", event = "VeryLazy" },

    -- Auto-close brackets/quotes in insert mode
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },

    -- Highlight colour codes inline (#ff0000, rgb(...), etc.)
    { "NvChad/nvim-colorizer.lua", event = "VeryLazy", config = true },

    -- Show available keymaps after pause digitizing prefix like <leader>
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            spec = {
                { "<leader>g", group = "git" },
                { "<leader>d", group = "debug" },
                { "<leader>t", group = "test" },
                { "<leader>s", group = "diagnostics" },
            },
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
}
