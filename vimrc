call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-eunuch'
Plug 'jlanzarotta/bufexplorer'
Plug 'godlygeek/tabular'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'rking/ag.vim'
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

Plug 'iperry/cscope_maps'
Plug 'iperry/snippets'
Plug 'iperry/inkpot'

" lazy load
Plug 'Valloric/YouCompleteMe'
call plug#end()

" Basic settings
" ==============
setglobal fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,latin1
set fileformat=unix
set fileformats=unix,dos
scriptencoding utf-8
set lazyredraw

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
set wildmode=longest,list
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

" Filetype-specific autocmds
" ==========================

" leave autoindent on, but disable cindent and smartindent
autocmd FileType text setlocal nocindent nosmartindent indentexpr=

" Only fold c and c++
autocmd FileType c,cpp setlocal foldmethod=indent


" Plugin configuration
" ====================
" YCM
let g:ycm_smart_case = 0
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_key_list_select_completion = ['<tab>', '<Down>']
let g:ycm_key_list_previous_completion = ['<S-tab>', '<Up>']
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
nnoremap <Leader>gt :YcmCompleter GoTo<CR>
nnoremap <Leader>fx :YcmCompleter FixIt<CR>

let g:ycm_rust_src_path = $RUST_SRC_PATH

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
