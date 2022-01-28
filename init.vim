call plug#begin('~/.config/nvim/plugged')
" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'ray-x/lsp_signature.nvim'

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
" Plug 'ptzz/lf.vim'
" Plug 'voldikss/vim-floaterm'
Plug 'scrooloose/nerdcommenter'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/goyo.vim'
Plug 'https://github.com/tpope/vim-surround'

" Theming
Plug 'ellisonleao/gruvbox.nvim'
call plug#end()

" --- Vim Settings ---
set smarttab
set cindent
set tabstop=2
set shiftwidth=2
set expandtab

set linebreak
set number
set relativenumber
set cursorline
set signcolumn=auto:1-3

set clipboard+=unnamedplus
set mouse=nv

set completeopt=menu,menuone,noselect

" colorscheme
set termguicolors
set background=dark
colorscheme gruvbox

" Python executables locations, verify by running `:checkhealth`
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

" Highlighting for better completion menus
" gray
highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#665c54
" blue
highlight! CmpItemAbbrMatch guibg=NONE guifg=#458588
highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#458588
" light blue
highlight! CmpItemKindVariable guibg=NONE guifg=#93a598
highlight! CmpItemKindInterface guibg=NONE guifg=#93a598
highlight! CmpItemKindText guibg=NONE guifg=#93a598
" pink
highlight! CmpItemKindFunction guibg=NONE guifg=#b16286
highlight! CmpItemKindMethod guibg=NONE guifg=#b16286
" fg
highlight! CmpItemKindKeyword guibg=NONE guifg=#f2e5bc
highlight! CmpItemKindProperty guibg=NONE guifg=#f2e5bc
highlight! CmpItemKindUnit guibg=NONE guifg=#f2e5bc
" ----------------

" --- Key Binds ---
" Enable spell check
map <F6> :setlocal spell! spelllang=en_us<CR>

" vsnip keybinds
" Jump forward or backward
 imap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
 smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
 imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
 smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
" -----------------

" --- Nerd Commenter ---
" filetype plugin for nerdcommenter
filetype plugin on

" nerdcommenter options
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDAltDelims_java = 1
let g:NERDAltDelims_c = 1
let g:NERDCommentEmptyLines = 1
" -----------------

lua <<EOF
  -- LSPconfig Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }
  vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  
  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client)
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
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-k>'] = cmp.mapping.select_prev_item(),
      ['<C-j>'] = cmp.mapping.select_next_item(),
      ['<C-o>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close();
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

  -- Insert ()'s after function or method completion item
  require('nvim-autopairs').setup{}
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
EOF
