call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-eunuch'
Plug 'godlygeek/tabular'
Plug 'vim-airline/vim-airline'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'embear/vim-localvimrc'
Plug 'ntpeters/vim-better-whitespace'
Plug 'rhysd/vim-clang-format'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'SirVer/ultisnips'
Plug 'rust-lang/rust.vim'
Plug 'jremmen/vim-ripgrep'

Plug 'iperry/cscope_maps'
Plug 'iperry/snippets'
Plug 'iperry/inkpot'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'nvim-orgmode/orgmode'

" completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" LSP
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

Plug 'olimorris/onedarkpro.nvim'
Plug 'folke/tokyonight.nvim'
call plug#end()

" Basic settings
" ==============
setglobal fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,latin1
set fileformat=unix
set fileformats=unix,dos
scriptencoding utf-8

" turn off backups
if !isdirectory($HOME."/.config/nvim/backupdir")
  silent! execute "!mkdir ~/.config/nvim/backupdir"
endif
set backupdir=~/.config/nvim/backupdir
set directory=~/.config/nvim/backupdir
set undodir=~/.config/nvim/backupdir

" nice big viminfo file
set viminfo='1000,f1,:1000,/1000
set history=1000

" enable filetype settings
filetype on
filetype plugin on
filetype indent on

" modelines are dumb
set nomodeline

" flush to disk on write
set fsync

" relative line numbers
set number
set relativenumber

" folding
set foldminlines=0
set foldnestmax=1
set foldlevel=99
set nofoldenable

" search options: highlight search, incremental search
set hlsearch
set incsearch
set ignorecase
set smartcase

" tab settings
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab

" readline-like tab completion
set wildmode=longest:full
set wildmenu

" show partial commands in the last line of the screen
set showcmd

" number of lines of context around cursor
set scrolloff=4

" enable the mouse
set mouse=a
set mousehide

" make backspace delet lots of things
set backspace=indent,eol,start

" status line always
set laststatus=2

" indent options
set autoindent
set smartindent
set cindent
set cinoptions=:0,p0,t0,(0
set cinwords=if,else,while,do,for,switch,case
set formatoptions=tcqr

set listchars=tab:▸\ ,eol:¬
set fillchars=fold:\ ,diff:\ 

" retain default vim compatibility
set startofline

" Highlight our cursor line
set cursorline

" Disable cursorline in diff-mode
autocmd FilterWritePre * setlocal nocursorline

" colors
syntax on
set background=dark
colorscheme inkpot

" Single space after period when joining
set nojoinspaces

" Make the preview window a bit bigger
set previewheight=20

" Clipboard settings
set clipboard=unnamedplus

" Special mappings and other
" ==========================
" Useful macros
nnoremap <F8> :r !date<CR>
nnoremap ;v :next $MYVIMRC<CR>
augroup VimReload
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END
nnoremap <Leader>vr :source $MYVIMRC<CR>
nnoremap <Leader>vm :e $MYVIMRC<CR>

" Diff specific commands
nnoremap <expr> H &diff ? ':diffget //2<cr>' : 'H'
nnoremap <expr> L &diff ? ':diffget //3<cr>' : 'L'
nnoremap <expr> J &diff ? ']cz.' : 'J'
nnoremap <expr> K &diff ? '[cz.' : 'K'

" readline shortcuts in command line mode
" see :h cmdline.txt for more
cnoremap <C-A>    <Home>
cnoremap <C-E>    <End>
cnoremap <C-K>    <C-E><C-U>
cnoremap <C-F>    <Right>
cnoremap <C-B>    <Left>
cnoremap <C-D>    <Del>
cnoremap <M-b>    <S-Left>
cnoremap <M-f>    <S-Right>

" press space to turn off highlighting and clear any message already displayed.
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" single line c commenting macro
inoremap <F2> <ESC>0i/**/<ESC>==lli<SPACE><SPACE><ESC>i
noremap <F2> <ESC>0i/**/<ESC>==lli<SPACE><SPACE><ESC>i

" multiline c commenting macro
inoremap <F3> <ESC>0i/*<ESC>==A<CR><CR><BS>/<ESC>kA<SPACE>
noremap <F3> <ESC>0i/*<ESC>==A<CR><CR><BS>/<ESC>kA<SPACE>

" linux kernel settings
function! LinuxFormatting()
    setlocal tabstop=8
    setlocal shiftwidth=8
    setlocal softtabstop=8
    setlocal textwidth=80
    setlocal noexpandtab

    setlocal cindent
    setlocal formatoptions=tcqlron
    setlocal cinoptions=:0,l1,t0,g0,(0
endfunction

" nvim: terminal mode exit to normal mode
if has('nvim')
    tnoremap <F1> <C-\><C-n>
endif

" unmap help
nnoremap <F1> <Nop>

" line wrap
set textwidth=80

" open vimrc
nnoremap <F12> :e $MYVIMRC<CR>
nnoremap <leader>r :source $MYVIMRC<CR>

" Resize buffers
nnoremap _ :resize -1<CR>
nnoremap + :resize +1<CR>
nnoremap <lt> :vertical resize -1<CR>
nnoremap > :vertical resize +1<CR>

" print ex command to buffer
function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    silent put=message
  endif
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

" Filetype-specific autocmds
" ==========================

" leave autoindent on, but disable cindent and smartindent
autocmd FileType text setlocal nocindent nosmartindent indentexpr=

" Only fold c and c++
autocmd FileType c,cpp setlocal foldmethod=indent


" Plugin configuration
" ====================
" ultisnips
let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" airline
let g:airline_extensions = ['branch', 'hunks']
let g:airline_powerline_fonts=1

" ag
if executable('ag')
  " Highlight search terms from ag
  let g:ag_highlight=1

  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

" vim-fugitive
nnoremap <Leader>gs :Gstatus<cr>
nnoremap <Leader>gcv :Gcommit --verbose<cr>
nnoremap <Leader>gr :Git! diff --staged<cr>

" tabularize
vnoremap <Leader>tn :'<,'>Tabularize /(/l4r0<cr>
vnoremap <Leader>t= :'<,'>Tabularize /=/l1r1<cr>
vnoremap <Leader>t\ :'<,'>Tabularize /\\/l4r0<cr>

" vim-diff-enhanced
" use patience diff by default
let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'

" vim-localvimrc
" only confirm one time for each lvimrc
let g:localvimrc_persistent=1

" Local machine-specific configuration
" Put any host-specific stuff in ~/.hvimrc
let s:host_vimrc = $HOME . '/.hvimrc'
if filereadable(s:host_vimrc)
    execute 'source ' . s:host_vimrc
endif

" clang-format
let g:clang_format#code_style = 'google'
let g:clang_format#style_options = {
    \ "Standard" : "C++11",
    \ "DerivePointerAlignment" : "false",
    \ "PointerAlignment" : "Right"}
function! ClangFormatQML()
  let tmpfile = tempname() . ".js"
  execute 'write ' . tmpfile
  execute '1,$d'
  execute '0r !clang-format ' . tmpfile
endfunction
nnoremap <Leader>cq :call ClangFormatQML()<cr>
nnoremap <Leader>cf :ClangFormat<cr>
vnoremap <Leader>cf :ClangFormat<cr>

" fzf
nnoremap <leader>ff :FZF<CR>
nnoremap <leader>fb :Buffers<CR>

" org-mode
autocmd FileType org nmap <buffer> <silent> <leader>O <Plug>OrgNewHeadingAboveNormal
autocmd FileType org nmap <buffer> <silent> <leader>o <Plug>OrgNewHeadingBelowAfterChildrenNormal

" Neovim section
lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp", "rust" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  -- fixits
  vim.keymap.set('n', '<Leader>fx', vim.lsp.buf.code_action, bufopts)
  -- show full line diagnostic
  vim.keymap.set('n', '<Leader>e', vim.lsp.diagnostic.show_line_diagnostics,
  bufopts)

  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local lspconfig = require('lspconfig')
require'lspconfig'.clangd.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  cmd =  { 'clangd',
           '--query-driver',
           '/home/perry/zephyr-sdk/arm-zephyr-eabi/bin/arm-zephyr-eabi-*',
  },
  root_dir = lspconfig.util.root_pattern(
          'compile_commands.json',
          'build/compile_commands.json')
--          '.clangd',
--          '.clang-tidy',
--          '.clang-format',
--          'compile_flags.txt',
--          'configure.ac',
--          '.git')
}

require("mason").setup()
require("mason-lspconfig").setup()
require'lspconfig'.rust_analyzer.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

 vim.g.tokyonight_style = "night"
 vim.g.tokyonight_colors = {
   bg = "#0c0c0c",
   fg = "#eeeeee",
   comment = "#cd8b00",
 }
 vim.cmd[[colorscheme tokyonight]]

require('orgmode').setup_ts_grammar()

-- Tree-sitter configuration
require'nvim-treesitter.configs'.setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {'org'}, -- Required for spellcheck, some LaTex highlights and code block highlights that do not have ts grammar
  },
  ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require('orgmode').setup({
  org_agenda_files = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
  org_default_notes_file = '~/Dropbox/org/refile.org',
})


EOF
