return {
    -- Disable the snacks.picker keymaps that would clash with ours.
    {
        "folke/snacks.nvim",
        opts = {
            picker = { enabled = false },
        },
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-telescope/telescope-ui-select.nvim",
        },
        cmd = { "Telescope" },
        keys = {
            {
                "<Leader><space>",
                -- fd excludes the usual build/dependency/cache directories
                "<Cmd>Telescope find_files find_command=fd,--type=file,--type=symlink,--hidden,--no-ignore,"
                    .. "--exclude=.DS_Store,--exclude=.git,--exclude=.terraform,--exclude=.gradle,"
                    .. "--exclude=.svelte-kit,--exclude=bin,--exclude=build,--exclude=coverage,"
                    .. "--exclude=dist,--exclude=node_modules,--exclude=target,--exclude=vendor,"
                    .. "--exclude=venv,--exclude=__pycache__<CR>",
                desc = "Find files",
            },
            { "<Leader>/", "<Cmd>Telescope live_grep<CR>", desc = "Live grep" },
        },
        config = function()
            local telescope = require("telescope")

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            -- Close with <Esc> instead of entering normal mode
                            ["<Esc>"] = require("telescope.actions").close,
                        },
                    },
                },
            })

            telescope.load_extension("fzf")
            telescope.load_extension("ui-select")
            telescope.load_extension("noice")
        end,
    },
}
