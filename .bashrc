alias ls='ls -G'
alias rm='rm -i'
alias mv='mv -i'
alias grep='grep --color=auto'
alias lsd='ls -d */'
alias saved='echo `pwd` > ~/.savedir'
alias showd='cat ~/.savedir'
alias god='cd `cat ~/.savedir`'
alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim -g'

export EDITOR=vim

export GREP_COLOR='1;32'
export PATH=$PATH

# Breaks scp if not enclosed in if
if [[ $- != *i* ]]; then
	# Shell is non-interactive.  Be done now
	return
fi

# Gimme fortunes
# if [ $TERM != "dumb" ]; then
#     echo
#     fortune
# #    xmodmap ~/.Xmodmap
#     echo
# fi

# git bash shell completion
. ~/.git-completion.bash

# Pretty prompts!
export PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[0;31m\]\$(__git_ps1) \[\033[00m\]"

# matlab/xmonad uigetfile hack
unset LANG;

if [ "$COLORTERM" = "gnome-terminal" ]
then
   export TERM=xterm-256color
fi
