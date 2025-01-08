local tools = require("config.tools")

return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = true,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        event = "VeryLazy",
        opts = {
            ensure_installed = tools.lsp,
        },
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim" },
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            ensure_installed = tools.dap,
            handlers = {},
        },
    },
    {
        "RubixDev/mason-update-all",
        dependencies = { "williamboman/mason.nvim" },
        cmd = { "MasonUpdateAll" },
        config = true,
    },
}
