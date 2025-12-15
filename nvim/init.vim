" Basic viml settings
" ==============
setglobal fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,latin1
set fileformat=unix
set fileformats=unix,dos
scriptencoding utf-8
set noswapfile

" turn off backups
if !isdirectory($HOME."/.config/nvim/backupdir")
  silent! execute "!mkdir ~/.config/nvim/backupdir"
endif
set backupdir=~/.config/nvim/backupdir
set directory=~/.config/nvim/backupdir
set undodir=~/.config/nvim/backupdir
set backup
set backupcopy=yes

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
set nofoldenable            " disable folding
au WinEnter * set nofen     " really disable folding
au WinLeave * set nofen
set diffopt+=context:99999  " really really disable folding

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
set wildmode=longest:list
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

" Single space after period when joining
set nojoinspaces

" Make the preview window a bit bigger
set previewheight=20

" For concealer plugins
set conceallevel=2

" Special mappings and other
" ==========================
" Useful macros
nnoremap <F8> :r !date<CR>
nnoremap ;v :next ~/.config/nvim/init.vim<CR>
augroup VimReload
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END
nnoremap <Leader>vr :source ~/.config/nvim/init.vim<CR>
nnoremap <Leader>vv :e ~/.config/nvim/init.vim<CR>
nnoremap <Leader>vl :e ~/.config/nvim/lua/init.lua<CR>

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

" vim-fugitive
nnoremap <Leader>gs :Gstatus<cr>
nnoremap <Leader>gcv :Gcommit --verbose<cr>
nnoremap <Leader>gr :Git! diff --staged<cr>

" tabularize
vnoremap <Leader>tn :'<,'>Tabularize /(/l4r0<cr>
vnoremap <Leader>t= :'<,'>Tabularize /=/l1r1<cr>
vnoremap <Leader>t\ :'<,'>Tabularize /\\/l4r0<cr>
vnoremap <Leader>t" :'<,'>Tabularize /"./l1r0<cr>

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

" Override coq/verilog detection
let g:filetype_v="verilog"

let g:easy_align_delimiters = {
\ '\': { 'pattern': '\\$' },
\ }

" Neovim section
lua << EOF
require('init')
EOF
