-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Strip trailing whitespaces on save
local clean_whitespace_group = vim.api.nvim_create_augroup("CleanWhitespace", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    group = clean_whitespace_group,
    command = "%s/\\s\\+$//e",
})

-- Enable spell checking for certain file types
local enable_spell_check_group = vim.api.nvim_create_augroup("EnableSpellCheck", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = enable_spell_check_group,
    pattern = { "*.txt", "*.md", "*.tex" },
    callback = function()
        vim.opt_local.spell = true
    end,
})
