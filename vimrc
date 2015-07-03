call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'kien/ctrlp.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'majutsushi/tagbar'
Plug 'godlygeek/tabular'
Plug 'Lokaltog/vim-easymotion'
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'ervandew/supertab'
Plug 'honza/vim-snippets'

" my snippets
Plug 'iperry/cscope_maps'
Plug 'iperry/snippets'
Plug 'iperry/inkpot'
" Load lazy
Plug 'SirVer/ultisnips', { 'on': [] }
Plug 'Valloric/YouCompleteMe', { 'on': [] }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTree' }
call plug#end()

set cinoptions=:0,p0,t0,(0
set cinwords=if,else,while,do,for,switch,case
set formatoptions=tcqr

set fileformat=unix
set fileformats=unix,dos

set listchars=tab:▸\ ,eol:¬
set relativenumber

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

augroup load_us_ycm
  autocmd!
  autocmd InsertEnter * call plug#load('ultisnips', 'YouCompleteMe')
                     \| call youcompleteme#Enable() | autocmd! load_us_ycm
augroup END

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

" unicode
if has("multi_byte")
  set encoding=utf-8
  setglobal fileencoding=utf-8
  set fileencodings=ucs-bom,utf-8,latin1
  scriptencoding utf-8
endif

" 4 space tabs
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

" case insensitive search, except capital letters
set ic
set smartcase

" readline-like tab completion
set wildmode=longest,list
set wildmenu

" show partial commands in the last line of the screen
set showcmd

" number of lines of context around cursor
set scrolloff=4

syntax on
set background=dark
set mouse=a
set mousehide

if has('clipboard')
     if has('unnamedplus')  " When possible use + register for copy-paste
         set clipboard=unnamedplus
     else         " On mac and Windows, use * register for copy-paste
         set clipboard=unnamed
     endif
endif

let c_space_errors = 1
" highlight trailing whitespace
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" match trailing whitespace and spaces before a tab
"autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/
" match only trailing whitespaces
autocmd Syntax * syn match ExtraWhitespace /\s\+$/
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkblue guibg=darkblue
" trailing ws function
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

colorscheme inkpot

" search options: highlight search, incremental search
set hlsearch
set incsearch
set ignorecase
set smartcase

" modelines are dumb
set nomodeline

" enable line numbers
set number

" nice big viminfo file
set viminfo='1000,f1,:1000,/1000
set history=1000

" make backspace delet lots of things
set backspace=indent,eol,start

" maintain indentation on new lines for no ft files
set autoindent
" clever indentation
set smartindent
" clever indentation for c
set cindent

" enable filetype settings
if has("eval")
filetype on
filetype plugin on
filetype indent on
endif

let g:toggleCurlyBrace = 1
inoremap { {<CR>}<ESC>ko
function! ToggleCurlyBraceClose()
    if g:toggleCurlyBrace
        inoremap { {
        let g:toggleCurlyBrace = 0
    else
        inoremap { {<CR>}<ESC>ko
        let g:toggleCurlyBrace = 1
    endif
endfunction
" map f4 to toggle curly brace closing
nmap <F4> :call ToggleCurlyBraceClose()<CR>

" single line c commenting macro
inoremap <F2> <ESC>0i/**/<ESC>==lli<SPACE><SPACE><ESC>i
noremap <F2> <ESC>0i/**/<ESC>==lli<SPACE><SPACE><ESC>i

" multiline c commenting macro
inoremap <F3> <ESC>0i/*<ESC>==A<CR><CR><BS>/<ESC>kA<SPACE>
noremap <F3> <ESC>0i/*<ESC>==A<CR><CR><BS>/<ESC>kA<SPACE>

" use f11 to toggle between 'paste' and 'nopaste'
set pastetoggle=<F10>
" Press Space to turn off highlighting and clear any message already displayed.
:nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" set status line always
set laststatus=2
" set status line format
"set statusline=%<%f\%h%m%r%=%-20.(line=%l\ \ col=%c%V\ \ tot=%L%)
set statusline=%<%f\%h%m%r%=%{fugitive#statusline()}%-20.(line=%l\ \ col=%c%V\ \ tot=%L%)

" readline shortcuts in command line mode
" see :h cmdline.txt for more
cnoremap <C-A>    <Home>
cnoremap <C-E>    <End>
cnoremap <C-K>    <C-E><C-U>
cnoremap <C-F>    <Right>
cnoremap <C-B>    <Left>
cnoremap <C-D>    <Del>

" nvim: terminal mode exit to normal mode
if has('nvim')
    tnoremap <F1> <C-\><C-n>
endif

set clipboard=unnamedplus


" turn off backups
set nobackup
set nowb
set noswapfile

" highlight whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Nicer signify
highlight clear SignColumn

"Airline
let g:airline_section_y=''
let g:airline_section_x=''
let g:airline_section_warning=''

" do not limit scan
let g:ctrlp_max_files = 0

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag -f %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" YCM
let g:ycm_confirm_extra_conf = 0
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>

" useful macros
nnoremap <F8> :r !date<CR>

" Diff specific commands
nnoremap <expr> H &diff ? ':diffget //2<cr>' : 'H'
nnoremap <expr> L &diff ? ':diffget //3<cr>' : 'L'
nnoremap <expr> J &diff ? ']cz.' : 'J'
nnoremap <expr> K &diff ? '[cz.' : 'K'
nnoremap <Leader>gs :Gstatus<cr>
nnoremap <Leader>bd :bd<cr>
vnoremap <Leader>tn :'<,'>Tabularize /(/l4r0<cr>

set foldmethod=syntax
set fillchars=fold:\ ,diff:\ 
