set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle/

call vundle#begin()
Plugin 'gmarik/vundle'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'inkpot'
Plugin 'kien/ctrlp.vim'
Plugin 'myusuf3/numbers.vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'majutsushi/tagbar'
Plugin 'godlygeek/tabular'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'mhinz/vim-signify'
Plugin 'bling/vim-airline'
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-scripts/c.vim'
Plugin 'iperry/cscope_maps'
call vundle#end()

filetype plugin indent on

set cinoptions=:0,p0,t0
set cinwords=if,else,while,do,for,switch,case
set formatoptions=tcqr

set fileformat=unix
set fileformats=unix,dos

function LinuxFormatting()
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

"colorscheme
if &t_Co == 256
   let g:inkpot_black_background = 1
   colorscheme inkpot
endif

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

" automatic curly brace closing
inoremap { {<CR>}<ESC>ko
let g:toggleCurlyBrace = 1
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

" Nicer vimdiff
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

"Airline
let g:airline_section_y=''
let g:airline_section_x=''
let g:airline_section_warning=''

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  " do not limit scan
  let g:ctrlp_max_files = 0
endif

" YCM
let g:ycm_confirm_extra_conf = 0
