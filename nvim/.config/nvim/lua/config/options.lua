-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.bigfile_size = 1024 * 1024 * 2.5 -- 2.5 MB
vim.g.mapleader = " " -- Set leader key
vim.g.maplocalleader = " " -- Set local leader key
vim.opt.completeopt = "menuone,noselect" -- Have a better completion experience
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.cmdheight = 2 -- Give more space for displaying messages
vim.opt.ignorecase = true -- Ignore case
vim.opt.inccommand = "split" -- Preview for find-replace command
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true }) -- 'I' to disable welcome screen
vim.opt.showcmd = true -- Show the (partial) command as it is being typed
vim.opt.spelllang = { "en_us" } -- Set default spell language
vim.opt.tabstop = 4 -- Set tab width to 4 spaces
