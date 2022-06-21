vim.opt.smarttab = true
vim.opt.cindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.linebreak = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'yes:2'

-- allow yank and put to/from system clipboard
vim.opt.clipboard = vim.opt.clipboard + 'unnamedplus'
vim.opt.mouse = 'nv'

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Set python executable locations, verify nvim is happy with :checkhealth
vim.g['python_host_prog'] = '/usr/bin/python'
vim.g['python3_host_prog'] = '/usr/bin/python3'


-- Enable Goyo when editing markdown files
-- TODO: doesn't work
-- vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
--   pattern = '*.md',
--   command = 'Goyo',
-- })
-- 
-- vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
--   pattern = '*',
--   command = 'Goyo!',
-- })

-- Highlighting and colorscheme
vim.api.nvim_set_hl(0, 'SpellBad', { ctermfg = "LightRed", cterm = { ['undercurl'] = true, ['italic'] = true }})
vim.api.nvim_set_hl(0, 'SpellCap', { ctermfg = "Green", cterm = { ['undercurl'] = true, ['italic'] = true }})
vim.api.nvim_set_hl(0, 'SpellRare', { ctermfg = "Cyan", cterm = { ['undercurl'] = true, ['italic'] = true }})
vim.api.nvim_set_hl(0, 'SpellLocal', { ctermfg = "Yellow", cterm = { ['undercurl'] = true, ['italic'] = true }})

-- color scheme
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.cmd([[ colorscheme gruvbox ]])
