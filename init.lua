-- Vim Plug --
vim.cmd([[
call plug#begin('~/.config/nvim/plugged')
" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'ray-x/lsp_signature.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'lewis6991/spellsitter.nvim'

" Snippets
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'

" LSP sources
Plug 'octaltree/cmp-look'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-vsnip'

" General Tools
Plug 'windwp/nvim-autopairs'
Plug 'scrooloose/nerdcommenter'
Plug 'Yggdroot/indentLine'
"Plug 'airblade/vim-gitgutter'
"Plug 'vim-airline/vim-airline'
Plug 'junegunn/goyo.vim'
Plug 'https://github.com/tpope/vim-surround'

" Theming
Plug 'ellisonleao/gruvbox.nvim'
call plug#end()
]])

-- VIM SETTINGS --
-------------------------
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
-------------------------
-- END VIM SETTINGS --

-- Enable Goyo when editing markdown files
-- TODO: doesn't work
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.md',
  command = 'Goyo',
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*',
  command = 'Goyo!',
})

-- Set python executable locations, verify nvim is happy with :checkhealth
-- TODO: can this be done with an api call
vim.cmd([[
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'
]])

-- KEY BINDINGS --
-------------------------
vim.api.nvim_set_keymap('', '<F6>', ':setlocal spell! spelllang=en_us<CR>', { nowait = true })

-- vsnip keyinds
-- jump forwards or backwards within snippet
vim.api.nvim_set_keymap('i', '<Tab>', 'vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<Tab>"', { expr = true })
vim.api.nvim_set_keymap('s', '<Tab>', 'vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<Tab>"', { expr = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-next)" : "<S-Tab>"', { expr = true })
vim.api.nvim_set_keymap('s', '<S-Tab>', 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-next)" : "<S-Tab>"', { expr = true })
-------------------------
-- END KEYBINDINGS --

-- LSPconfig Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  require "lsp_signature".on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    hint_enable = false,
    handler_opts = {
      border = "rounded"
    }
  })

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
end

local capablilities = vim.lsp.protocol.make_client_capabilities()
capablilities = require('cmp_nvim_lsp').update_capabilities(capablilities)

local lspconfig = require('lspconfig')
local servers = { 'bashls', 'clangd', 'pyright' }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capablilities = capablilities,
   }
end

-- Setup nvim-cmp.
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },

  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<C-o>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
      }),
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp', max_item_count = 5 },
    { name = 'vsnip', max_item_count = 5 }
  }, {
    { name = 'look', keyword_length = 5, max_item_count = 5, option = { convert_case = true, loud = true } }
  }, {
    { name = 'path', max_item_count = 5 },
    { name = 'buffer', keyword_length = 5, max_item_count = 3 }
  }),

  experimental = {
    native_menu = false,
    ghost_text = true,
  }
})

-- treesitter setup
require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = { 'c', 'lua', 'java', 'javascript' },
  
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = true,
  },
}

vim.api.nvim_set_hl(0, 'SpellBad', { ctermfg = "LightRed", cterm = { ['undercurl'] = true, ['italic'] = true }})
vim.api.nvim_set_hl(0, 'SpellCap', { ctermfg = "Green", cterm = { ['undercurl'] = true, ['italic'] = true }})
vim.api.nvim_set_hl(0, 'SpellRare', { ctermfg = "Cyan", cterm = { ['undercurl'] = true, ['italic'] = true }})
vim.api.nvim_set_hl(0, 'SpellLocal', { ctermfg = "Yellow", cterm = { ['undercurl'] = true, ['italic'] = true }})

-- TODO: doesn't seem to be doing anything at the moment
require('spellsitter').setup{
  hl = 'SpellBad',
  captures = { 'comment' },
}

-- Insert ()'s after function or method completion item
require('nvim-autopairs').setup{}
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

-- color scheme
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.cmd([[ colorscheme gruvbox ]])
