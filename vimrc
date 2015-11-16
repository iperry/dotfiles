call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'kien/ctrlp.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'majutsushi/tagbar'
Plug 'godlygeek/tabular'
Plug 'Lokaltog/vim-easymotion'
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'ervandew/supertab'
Plug 'honza/vim-snippets'
Plug 'rking/ag.vim'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'embear/vim-localvimrc'
Plug 'ntpeters/vim-better-whitespace'
Plug 'jiangmiao/auto-pairs'

" my snippets
Plug 'iperry/cscope_maps'
Plug 'iperry/snippets'
Plug 'iperry/inkpot'

" lazy load
Plug 'SirVer/ultisnips', { 'on': [] }
Plug 'Valloric/YouCompleteMe', { 'on': [] }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTree' }
call plug#end()

" Basic settings
" ==============
setglobal fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,latin1
set fileformat=unix
set fileformats=unix,dos
scriptencoding utf-8

" turn off backups
set nobackup
set nowb
set noswapfile

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

" search options: highlight search, incremental search
set hlsearch
set incsearch
set ignorecase
set smartcase

" tab settings
set tabstop=4
set shiftwidth=4
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
let g:ycm_confirm_extra_conf = 0
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Autoload ultisnips and ycm only on insert mode
augroup load_us_ycm
  autocmd!
  autocmd InsertEnter * call plug#load('ultisnips', 'YouCompleteMe')
                     \| call youcompleteme#Enable() | autocmd! load_us_ycm
augroup END

" airline
let g:airline_section_warning=''
let g:airline_powerline_fonts=1

" ctrlp: do not limit scan
let g:ctrlp_max_files = 0

" ag
if executable('ag')
  " Highlight search terms from ag
  let g:ag_highlight=1

  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag -f %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" vim-fugitive
nnoremap <Leader>gs :Gstatus<cr>
nnoremap <Leader>gcv :Gcommit --verbose<cr>
nnoremap <Leader>gr :Git! diff --staged<cr>

" tabularize
vnoremap <Leader>tn :'<,'>Tabularize /(/l4r0<cr>

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
