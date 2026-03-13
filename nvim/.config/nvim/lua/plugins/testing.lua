-- Testing (neotest)
-- neotest-go is now maintained under the nvim-neotest org.
-- neotest-vim-test still exists but is a heavy fallback; keep only if you
-- rely on vim-test adapters for languages not covered by neotest natively.

return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "vim-test/vim-test",
        },
        keys = {
            {
                "<Leader>tn",
                function() require("neotest").run.run() end,
                desc = "Run nearest test",
            },
            {
                "<Leader>tf",
                function()
                    require("neotest").run.run(vim.fn.expand("%"))
                    require("neotest").summary.open()
                end,
                desc = "Run all tests in file",
            },
            {
                "<Leader>ta",
                function()
                    require("neotest").run.run(vim.fn.getcwd())
                    require("neotest").summary.open()
                end,
                desc = "Run all tests in suite",
            },
            {
                "<Leader>tu",
                function() require("neotest").summary.toggle() end,
                desc = "Toggle test summary UI",
            },
        },
        config = function()
            require("neotest").setup({
                icons = {
                    failed  = "󰅚",
                    passed  = "󰗡",
                    running = "󰐍",
                    unknown = "󰘥",
                },
                adapters = {
                    require("neotest-go"),
                    require("neotest-vim-test")({ ignore_filetypes = { "go" } }),
                },
            })
        end,
    },
}
