alias rm='rm -i'
#alias cp='cp -i'
#alias startx='startx -- -dpi 75'
alias mv='mv -i'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias lsd='ls -d */'
alias kq='konqueror'
alias jsim='java -jar /home/perry/work/svn/6.004/jsim/jsim.jar -Xms8m -Xmx32m'
alias tmsim='java -jar /home/perry/work/svn/6.004/jsim/tmsim.jar -Xms8m -Xmx32m'
alias bsim='java -jar /home/perry/work/svn/6.004/jsim/bsim.jar -Xms8m -Xmx32m'
alias rasm='/usr/games/bin/dosbox /home/perry/work/6.115/rasm.bat'
alias mplayer='mplayer -softvol -softvol-max 1000' 
alias kqed='mplayer http://kqed-ice.streamguys.org:80/kqedradio-ch-e1'
alias bbcnews='mplayer mms://livewmstream-ws.bbc.co.uk.edgestreams.net/reflector:38288'
alias jhead-iso='jhead -n%Y-%m-%d_%H:%M:%S'
alias wbur='mplayer http://wbur-sc.streamguys.com:80'
alias screen='TERM=screen screen'
alias wmbr='mplayer http://headphones.mit.edu:8000/'
alias saved='echo `pwd` > ~/.savedir'
alias showd='cat ~/.savedir'
alias god='cd `cat ~/.savedir`'
alias sd='svn diff --diff-cmd=meld'
alias maplemake='make LINKER=lanchon-stm32-user-ram.ld DEFFLAGS=VECT_TAB_RAM'

export EDITOR=vim

# varmosa junk
export TARGET_IP=n810
export SCP='rsync -Pax'
export TARGET_PATH=/root/varmosa
export TARGET_USER=root
alias vmake='make CROSS_COMPILE=arm-none-linux-gnueabi- KERNEL_SOURCE=../kernel'

export GREP_COLOR='1;32'
export PATH=/home/perry/opt/arm-2010q1/arm-none-linux-gnueabi/bin:/home/perry/opt/arm-2010q1/bin:/home/perry/opt/jre1.6.0_07/bin:/home/perry/opt/jdk1.6.0/bin:/home/perry/programs/matlab/bin:/home/perry/opt/matlab/bin:/home/perry/bin:/home/perry/opt/eagle/eagle-5.6.0/bin:/home/perry/opt/foxit/1.1-release:/home/perry/opt/jdk1.5.0_22/bin:$PATH

# Breaks scp if not enclosed in if
if [[ $- != *i* ]]; then
	# Shell is non-interactive.  Be done now
	return
fi

# Gimme fortunes
if [ $TERM != "dumb" ]; then
    echo
    fortune
#    xmodmap ~/.Xmodmap
    echo 
fi

. ~/.git-completion.bash
# Pretty prompts!
export PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[0;31m\]\$(__git_ps1) \[\033[00m\]"

#matlab/xmonad uigetfile hack
unset LANG;


if [ "$COLORTERM" = "gnome-terminal" ]
then
   export TERM=xterm-256color
fi

export MVP_HOST_OS=android
export MVP_HOST_BOARD=zoom2

#export MAPLE_TARGET=ram
