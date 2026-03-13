return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            local dapui = require("dapui")

            dapui.setup()

            vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "Toggle debugging UI" })
            vim.keymap.set("n", "<Leader>dK", function()
                dapui.eval(nil, { enter = true })
            end, { desc = "Evaluate symbol under cursor" })
        end,
    },

    {
        "mfussenegger/nvim-dap",
        dependencies = {
            { "theHamsta/nvim-dap-virtual-text", config = true },
        },
        cmd = { "DapToggleBreakpoint" },
        keys = {
            {
                "<Leader>db",
                function() require("dap").toggle_breakpoint() end,
                desc = "Toggle breakpoint",
            },
            {
                "<Leader>dB",
                function()
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                desc = "Set conditional breakpoint",
            },
            { "<Leader>dd", function() require("dap").continue()   end, desc = "Start / continue" },
            { "<Leader>dn", function() require("dap").step_over()  end, desc = "Step over" },
            { "<Leader>di", function() require("dap").step_into()  end, desc = "Step into" },
            { "<Leader>do", function() require("dap").step_out()   end, desc = "Step out" },
        },
        config = function()
            vim.fn.sign_define("DapBreakpoint",          { text = "󰌖", texthl = "", linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "󰌕", texthl = "", linehl = "", numhl = "" })
        end,
    },
}
