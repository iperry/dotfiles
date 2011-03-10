" Notes for me:
" cmap handles command-line mappings
" imap handles insert-only mappings
" map maps keys in normal, visual, and operator-pending mode
" map! maps keys in command in insert modes
" nmap maps keys in normal mode only
" omap maps keys in operator-pending mode only
" vmap maps keys in visual mode only

" Keep it sane.
set nocp
set cinoptions=:0,p0,t0
set cinwords=if,else,while,do,for,switch,case
set formatoptions=tcqr

" 4 space tabs
set tabstop=8
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

" duh
syntax on

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

" colorscheme
if &t_Co == 256
   let g:inkpot_black_background = 1
   colorscheme inkpot
endif

" search options: highlight search, incremental search
set hlsearch
set incsearch

" modelines are dumb
set nomodeline

" enable line numbers
set number

" nice big viminfo file
set viminfo='1000,f1,:1000,/1000
set history=500

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
set statusline=%<%f\%h%m%r%=%-20.(line=%l\ \ col=%c%V\ \ tot=%L%)

" readline shortcuts in command line mode
" see :h cmdline.txt for more
cnoremap <C-A>    <Home>
cnoremap <C-E>    <End>
cnoremap <C-K>    <C-E><C-U>
cnoremap <C-F>    <Right>
cnoremap <C-B>    <Left>

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

