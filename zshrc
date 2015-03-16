source ~/.zsh/antigen-hs/init.zsh

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

export EDITOR=vim
export TERM=xterm-256color

setopt prompt_subst
setopt extendedglob
setopt share_history
setopt noautomenu
setopt nomenucomplete
unsetopt nomatch

# locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# vi mode
# bindkey -v
# export KEYTIMEOUT=1

# Colors
autoload -U colors && colors

# colors for ls
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad
export LS_OPTIONS='--color=auto'
ls --color=auto &> /dev/null && alias ls='ls --color=auto' ||

# Colors for grep
export GREP_OPTIONS='--color=auto'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[red]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[red]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}:dirty"
ZSH_THEME_GIT_PROMPT_CLEAN=""
DISABLE_UNTRACKED_FILES_DIRTY="true"

local user_host='%{$terminfo[bold]$fg[green]%}%n@%m%{$reset_color%}'
local current_dir='%{$terminfo[bold]$fg[blue]%} %~%{$reset_color%}'
local git_branch='$(git_prompt_info)'
local prompt_cursor='[%{$terminfo[bold]$fg[cyan]%}$%{$reset_color%}]'
local prompt_time='[%{$fg[yellow]%}%*${reset_color%}]'

PROMPT="${prompt_time} ${user_host} ${current_dir} ${git_branch}
${prompt_cursor} "

# Completion
##
setopt hash_list_all            # hash everything before completion
setopt completealiases          # complete alisases
setopt always_to_end            # when completing from the middle of a word, move the cursor to the end of the word
setopt complete_in_word         # allow completion from within a word/phrase
setopt correct                  # spelling correction for commands
setopt list_ambiguous           # complete as much of a completion until it gets ambiguous.

zstyle ':completion::complete:*' use-cache on               # completion caching, use rehash to clear
zstyle ':completion:*' cache-path ~/.zsh/cache              # cache path
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # ignore case
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}       # colorz !
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate # list of completers to use

# sections completion !
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $'\e[00;34m%d'
zstyle ':completion:*:messages' format $'\e[00;31m%d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true

zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=29=34"
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always
users=(perry root)           # because I don't care about others
zstyle ':completion:*' users $users

autoload -U compinit
compinit
zmodload -i zsh/complist

# aliases
alias zm='vim ~/.zshrc; . ~/.zshrc'
alias zrl='. ~/.zshrc'
alias saved='echo `pwd` > ~/.savedir'
alias showd='cat ~/.savedir'
alias god='cd `cat ~/.savedir`'
alias gs='git status'
alias gsa='git stash apply'
alias gst='git stash'
alias vi='vim'
alias gci='git commit --verbose'
alias gd='git diff'
alias gl='git log'
alias glp='git log -p'
alias gdc='git diff --cached'
alias gau='git add -u :/'
alias gca='git commit --amend'
alias ga='git add'
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias vim='nvim'
alias vm='vim ~/.vimrc'

# path
path[1,0]=~/bin
path[1,0]=~/opt/llvm/bin
