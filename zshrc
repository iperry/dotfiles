# disable antigen-hs by default, use basic set of plugins
# source ~/.zsh/antigen-hs/init.zsh
source ~/.zsh/bashmarks.sh
source ~/.zsh/extract.plugin.zsh
source ~/.zsh/zsh-history-substring-search.zsh

# basic settings
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob
setopt share_history
setopt noautomenu
setopt nomenucomplete
unsetopt nomatch

export EDITOR=nvim
export TERM=xterm-256color

# locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# vi mode
zmodload zsh/terminfo
bindkey -v
export KEYTIMEOUT=1
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^w' backward-kill-word
bindkey '^K' kill-line
bindkey '^r' history-incremental-search-backward
bindkey '^b' backward-word
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey -M vicmd "?" history-incremental-search-backward
bindkey -M vicmd "/" history-incremental-search-forward
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Colors
autoload -U colors && colors

# prompt settings
setopt prompt_percent
setopt prompt_subst
autoload -U compinit promptinit
compinit
promptinit

# chosen from 256 color palette
local red=196
local green=10
local blue=14
local yellow=11

# Track vi mode and color the prompt
vi_ins_mode="%F{${green}}"
vi_cmd_mode="%F{${red}}"
vi_mode=$vi_ins_mode
function zle-keymap-select {
  vi_mode="${${KEYMAP/vicmd/${vi_cmd_mode}}/(main|viins)/${vi_ins_mode}}"
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-finish {
  vi_mode=$vi_ins_mode
  zle reset-prompt
}
zle -N zle-line-finish
function TRAPINT() {
  vi_mode=$vi_ins_mode
  return $(( 128 + $1 ))
}

function vi_mode_prompt() {
    vi_mode="${${KEYMAP/vicmd/${vi_cmd_mode}}/(main|viins)/${vi_ins_mode}}"
    if [[ "$vi_mode" == "" ]]; then
        vi_mode=${vi_ins_mode}
    fi
    echo ${vi_mode}${prompt_cursor}
}

# for async update on git prompt
# based on https://github.com/byplayer/dot.zsh.d/blob/master/lib/prompt.zsh
mkdir -p ${TMPPREFIX}

PROMPT_WORK_FNAME=zsh_prompt_hook.$$
PROMPT_WORK=${TMPPREFIX}/${PROMPT_WORK_FNAME}

function _prompt_is_in_git {
  if git rev-parse 2> /dev/null; then
    echo true
  else
    echo false
  fi
}

function _prompt_git_branch_name {
  echo $(git symbolic-ref --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null)
}

function _prompt_git_short_rev {
  local rev=''
  rev="$(git rev-parse --short HEAD 2> /dev/null)"
  if [[ -n ${rev} ]];  then;
      echo -n "${rev}|";
  fi
}

function _prompt_git_action {
  local rebase_formatted='|REBASE'
  local apply_formatted='|AM'
  local rebase_interactive_formatted='|REBASE-i'
  local rebase_merge_formatted='|REBASE-m'
  local merge_formatted='|MERGING'
  local cherry_pick_formatted='|CHERRY-PICKING'
  local bisect_formatted='|BISECTING'
  git_dir=$(git rev-parse --git-dir)
  for action_dir in \
    "${git_dir}/rebase-apply" \
    "${git_dir}/rebase"
  do
    if [[ -d "$action_dir" ]] ; then
      if [[ -f "${action_dir}/rebasing" ]] ; then
        print "$rebase_formatted"
      elif [[ -f "${action_dir}/applying" ]] ; then
        print "$apply_formatted"
      else
        print "${rebase_formatted}${apply_formatted}"
      fi

      return 0
    fi
  done

  for action_dir in \
    "${git_dir}/rebase-merge/interactive" \
    "${git_dir}/.dotest-merge/interactive"
  do
    if [[ -f "$action_dir" ]]; then
      print "$rebase_interactive_formatted"
      return 0
    fi
  done

  for action_dir in \
    "${git_dir}/rebase-merge" \
    "${git_dir}/.dotest-merge"
  do
    if [[ -d "$action_dir" ]]; then
      print "$rebase_merge_formatted"
      return 0
    fi
  done

  if [[ -f "${git_dir}/MERGE_HEAD" ]]; then
    print "$merge_formatted"
    return 0
  fi

  if [[ -f "${git_dir}/CHERRY_PICK_HEAD" ]]; then
    print "$cherry_pick_formatted"
    return 0
  fi

  if [[ -f "${git_dir}/BISECT_LOG" ]]; then
    print "$bisect_formatted"
    return 0
  fi
}

function _prompt_git_dirty() {
    local git_status=''
    git_status=$(command git status --porcelain --untracked-files=no 2> /dev/null | tail -n1)
    if [[ -n $git_status ]]; then
        echo "%F{${red}}✗%{$reset_color%}"
    else
        echo "%F{${green}}✔%{$reset_color%}"
    fi
}

function _git_stat_update {
    if [ $(_prompt_is_in_git) = "true" ] ; then
        echo $(pwd) > ${PROMPT_WORK}
        echo -n "%F{${red}}(" >> ${PROMPT_WORK}
        echo -n "$(_prompt_git_short_rev)" >> ${PROMPT_WORK}
        echo -n "$(_prompt_git_branch_name)" >> ${PROMPT_WORK}
        echo -n "$(_prompt_git_action)" >> ${PROMPT_WORK}
        echo -n "$(_prompt_git_dirty)%F{${red}})" >> ${PROMPT_WORK}

        kill -s USR2 $$
    fi
}

function _async_git_stat_update {
    PROMPT=$PROMPT_BASE

    # fail safe to clean up dead file
    if [ -f ${PROMPT_WORK} ] ; then
        find ${TMPPREFIX} -name ${PROMPT_WORK_FNAME} -mmin +5 -type f -exec rm -f {} \;
    fi

    if [ ! -f ${PROMPT_WORK} ] ; then
        _git_stat_update &!
    fi
    git_info=''
}

function TRAPUSR2 {
  if [ -f ${PROMPT_WORK} ] ; then
    lines=( ${(@f)"$(< ${PROMPT_WORK})"} )
    if [[ "$lines[1]" = "$(pwd)" ]] ; then
      git_info=$lines[2]
    fi
    rm -f ${PROMPT_WORK}
    # Force zsh to redisplay the prompt.
    zle && zle reset-prompt
  fi
}
add-zsh-hook precmd _async_git_stat_update

user_host="%F{${green}}%n@%m%{$reset_color%}"
current_dir="%F{${blue}} %~%{$reset_color%}"
prompt_time="[%F{${yellow}}%*${reset_color%}]"
prompt_cursor="zsh▸%{$reset_color%}"

PROMPT_BASE='${prompt_time} ${user_host} ${current_dir} ${git_info}
$(vi_mode_prompt) '

PROMPT='${PROMPT_BASE}'

# case insensitive search on less
export LESS=-Ri

# colors for ls
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad
export LS_OPTIONS='--color=auto'
ls --color=auto &> /dev/null && alias ls='ls --color=auto' ||

# Colors for grep
export GREP_OPTIONS='--color=auto'

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
alias gc=gci
alias gd='git diff'
alias gl='git log --stat'
alias glp='git log --stat -p'
alias gdc='git diff --cached'
alias gau='git add -u :/'
alias gca='git commit --amend --verbose'
alias ga='git add'
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias vim='nvim'
alias vm='vim ~/.vimrc'
alias rm='rm -i'
alias startx='ssh-agent startx'

# path
path[1,0]=~/bin
path[1,0]=~/opt/llvm/bin

# Print sysinfo on arch interactive terminals
SYSINFO=`which archey3`
if [[ -e $SYSINFO ]]
then
    archey3
fi

# Use clang by default whenever we can
export CC=clang
export CXX=clang++
# ccache needs this set for some reason when used with clang
export CCACHE_CPP2=yes
export CCACHE_SLOPPINESS=pch_defines,time_macros

# Java xmonad shit
export _JAVA_AWT_WM_NONREPARENTING=1

# rtags
HAVE_RTAGS=`which rc`
if [[ -e $HAVE_RTAGS ]]
then
  export USE_RTAGS=1
fi

# fzf
export FZF_DEFAULT_COMMAND='ag -g ""'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
