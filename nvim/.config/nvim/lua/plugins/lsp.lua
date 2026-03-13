-- LSP configuration
-- Extends LazyVim's built-in LSP setup rather than replacing it.
-- LazyVim (with mason-lspconfig v2) no longer uses setup_handlers().
-- Server installation is managed via mason-lspconfig opts in tools.lua / plugins/tools.lua.
-- Server-specific settings go in the `servers` table below.

return {
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            -- ── Diagnostic signs (Neovim >= 0.10 API) ────────────────────────────
            -- The old vim.fn.sign_define() approach is deprecated for diagnostics.
            opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "󰅚 ",
                        [vim.diagnostic.severity.WARN]  = "󰀪 ",
                        [vim.diagnostic.severity.HINT]  = "󰌶 ",
                        [vim.diagnostic.severity.INFO]  = "󰋽 ",
                    },
                },
            })

            -- ── Per-server settings ───────────────────────────────────────────────
            -- Add server-specific configuration here. Mason will install them;
            -- LazyVim wires them up automatically.
            opts.servers = opts.servers or {}
            -- Example: override lua_ls settings
            -- opts.servers.lua_ls = {
            --     settings = { Lua = { workspace = { checkThirdParty = false } } }
            -- }
        end,
        init = function()
            -- ── LSP keymaps (attached per-buffer via LspAttach) ──────────────────
            -- We use LspAttach instead of the deprecated on_attach approach so that
            -- keymaps survive LSP restarts and work with LazyVim's own keymap system.
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
                callback = function(event)
                    local bufnr = event.buf
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    local telescope_ok, telescope = pcall(require, "telescope.builtin")

                    local function buf_opts(desc)
                        return { noremap = true, silent = true, buffer = bufnr, desc = desc }
                    end

                    -- Navigation (prefer Telescope when available)
                    if telescope_ok then
                        vim.keymap.set("n", "gd", telescope.lsp_definitions,     buf_opts("Go to definition"))
                        vim.keymap.set("n", "gi", telescope.lsp_implementations, buf_opts("Go to implementation"))
                        vim.keymap.set("n", "gr", telescope.lsp_references,      buf_opts("Go to references"))
                    end

                    vim.keymap.set("n", "K",          vim.lsp.buf.hover,       buf_opts("Show symbol documentation"))
                    vim.keymap.set("n", "<Leader>r",  vim.lsp.buf.rename,      buf_opts("Rename symbol"))
                    vim.keymap.set("n", "<Leader>a",  vim.lsp.buf.code_action, buf_opts("Run code action"))

                    -- Manual format (LazyVim/conform handles format-on-save automatically)
                    vim.keymap.set("n", "<Leader>f", function()
                        vim.lsp.buf.format({ async = true })
                    end, buf_opts("Format current file"))

                    -- Diagnostics
                    vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, buf_opts("Show line diagnostics"))
                    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, buf_opts("Previous diagnostic"))
                    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, buf_opts("Next diagnostic"))

                    -- Format on save via LSP (only when no conform formatter is active)
                    if client and client:supports_method("textDocument/formatting") then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = vim.api.nvim_create_augroup("LspFormatOnSave_" .. bufnr, { clear = true }),
                            buffer = bufnr,
                            callback = function()
                                -- conform.nvim takes priority when present; this is a fallback.
                                local conform_ok, conform = pcall(require, "conform")
                                if not conform_ok then
                                    vim.lsp.buf.format({ bufnr = bufnr })
                                end
                            end,
                        })
                    end
                end,
            })
        end,
    },
}
