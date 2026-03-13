local tools = require("config.tools")

return {
    {
        "mason-org/mason.nvim",
        build = ":MasonUpdate",
        lazy = false,
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
        event = "VeryLazy",
        opts = {
            ensure_installed = tools.lsp,
        },
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mason-org/mason.nvim" },
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            ensure_installed = tools.dap,
            handlers = {},
        },
    },
    {
        "RubixDev/mason-update-all",
        dependencies = { "mason-org/mason.nvim" },
        cmd = { "MasonUpdateAll" },
        opts = {},
    },
}
