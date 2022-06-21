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

-- Bring in basic settings/options
require("settings") -- lua/settings.lua

-- Bring in key bindings
require("bindings") -- lua/bindings.lua

-- Setup LSP config
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local opts = { noremap = true, silent = true }
local on_attach = function(client, bufnr)
  require("lsp_signature").on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    hint_enable = false
  })

  -- lua/bindings.lua
  on_attach_lsp_config_bindings(bufnr)
end

local capablilities = vim.lsp.protocol.make_client_capabilities()
capablilities = require("cmp_nvim_lsp").update_capabilities(capablilities)

local lspconfig = require("lspconfig")
local servers = { 'bashls', 'clangd', 'pyright', 'marksman' }

-- setup each of the language servers
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
    { name = 'path', max_item_count = 10 },
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
  ensure_installed = { 'c', 'python', 'lua', 'java', 'javascript' },
  
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = true,
  },
}

-- TODO: doesn't seem to be doing anything at the moment
-- require('spellsitter').setup{
--   --hl = { 'SpellBad', 'SpellCap', 'SpellRare', 'SpellLocal' },
--   --hl = 'SpellBad',
--   captures = { 'comment' },
-- }

-- Insert ()'s after function or method completion item
require('nvim-autopairs').setup{}
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

