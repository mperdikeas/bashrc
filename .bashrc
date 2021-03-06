# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# 2348sd723asd97987 added 2012.04.03 from: http://www.jeremysands.com/archlinux/gentoo-bashrc-2008.0
# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.

if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi
# 2348sd723asd97987<-end

#export TERM=xterm-color
export TERM=xterm-256color # support 256 colors - you also have to do a: apt-get install ncurses-term
                           # to test whether the terminal really exports 256 colors, apart from echo $TERM
                           # you ought to do a 'tput colors' (should print 256)

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[1;32m\]\u@\h\[\033[00m\]:\[\033[1;33m\]\w\[\033[00m\]#\n$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w#\n$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Keep it simple if running in emacs (http://unix.stackexchange.com/a/175770/24044)
case "$EMACS" in
    t)
    PROMPT_COMMAND=
    PS1="[\u@\h:\w]$ "
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    if [ -f ~/.dircolors ]; then
        eval $(dircolors -b ~/.dircolors)
    else
        eval "`dircolors -b`"
    fi
    alias ls='ls -lAF --color'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

alias l='ls -alF --color'

HISTSIZE=10000
HISTIGNORE=ls:ls\ -la:history

if [ -f ~/.bashrc_thisnode ]; then
    . ~/.bashrc_thisnode
fi

# disable the below two lines due to a problem with groovy [https://issues.apache.org/jira/browse/GROOVY-1386]
#: ${JAVA_HOME:?"WARNING - Java home not set"}
#export CLASSPATH=$JAVA_HOME/jre/lib/rt.jar:.

# pushd and popd aliases
alias p='pushd'
alias o='popd'

# 2012-02-22 using extglob shell option for more powerfull globs (e.g. ls !(*.cpp) )
shopt -s extglob

# 2012-03-16 some more aliases
# This is GOLD for finding out what is taking so much space on your drives!
alias diskspace="du -S | sort -n -r |more"

# Show me the size (sorted) of only the folders in this directory
alias folders="find . -maxdepth 1 -type d -print | xargs du -sh | sort -rn"

#add colour to Ant output
export ANT_ARGS='-logger org.apache.tools.ant.listener.AnsiColorLogger'

alias emacs="emacs -nw"
export PATH=$PATH:~/tools
export MONO_PATH=/opt/FSharp-2.0.0.0/bin
export ANT_OPTS="-Xms256m -Xmx1024m -XX:MaxPermSize=256m -Dant.logger.defaults=$HOME/bashrc/AnsiColorLogger.override"

# below instructions from: https://www.emacswiki.org/emacs/EmacsAsDaemon
export EDITOR="emacsclient -t"
export VISUAL="emacsclient -c -a emacs"
export ALTERNATE_EDITOR=""
# this should be implemented as a script (see ~/tools/prompttest2)
# alias emax="emacsclient -t"                       # used to be "emacs -nw"
# I don't think I need the below any more:
#alias semac="sudo emacsclient -t"                # used to be "sudo emacs -nw"
#alias emacsc="emacsclient -c -a emacs"           # new - opens the GUI with alternate non-daemon

# overriding on demand the 'svn diff' tool customization I 've used (do a grep diff ~/.subversion/config  to find out how and which tool it points to?)
# shouldn't I perhaps use a svn alias intead of a bash alias ?
alias svn-diff-traditional='svn diff --diff-cmd /usr/bin/diff'
export SVN_EDITOR=emacs
alias grep='grep --color=always'
alias git-fire-away='git add . -A && git commit -m ".." && git push'
alias ack='ack-grep'
export LANG=en_US.UTF-8
export LC_ALL=$LANG

# for some reason autojump is located in different locations in my work environment versus the home environment
# autojump (maintained in ~/software-deployed in my work system where the install.sh and uninstall.sh scripts are located)
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh
# autojump @ home (I will have to merge it with the above)
[[ -s /usr/share/autojump/autojump.sh ]] && . /usr/share/autojump/autojump.sh

alias h='xdg-open .'

alias bd='. bd -s'

function sedescape {
  echo "$1" | sed -e 's/[]\/$*.^|[]/\\&/g'
}
export -f sedescape
# example use:
#     $ sedescape 'how < do you (escape [this] & "that"). ? >'
#     how < do you (escape \[this\] & "that")\. ? >
#     $

alias e='emax' # now this points to the emax tool which automatically either spawns a new emacs daemon or asks you which emacs daemon to connect to

export NVM_DIR="~/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

alias lsblk='lsblk -o name,mountpoint,label,size,uuid'
shopt -s dotglob # enable dot globbing

# https://spin.atomicobject.com/2016/05/28/log-bash-history/ - START
. ~/.bashrc.local.environment
if [ -z ${CUSTOM_HISTORY_LOG_DIR_BASE+x} ]; then # http://stackoverflow.com/a/13864829/274677
    printf "\n\n\n\n\n\t\tCUSTOM_HISTORY_LOG_DIR_BASE is unset\n\n\n";
fi
EFFECTIVE_DIR="$CUSTOM_HISTORY_LOG_DIR_BASE/.logs"

if [ -z ${CACHE_OF_OBLIVION+x} ]; then # http://stackoverflow.com/a/13864829/274677
    printf "\n\n\n\n\n\t\tCACHE_OF_OBLIVION is unset\n\n\n";
else
    export CACHE_OF_OBLIVION=${CACHE_OF_OBLIVION}
fi



mkdir -p ${EFFECTIVE_DIR}
export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> '"${EFFECTIVE_DIR}"'/bash-history-$(date "+%Y-%m-%d").log; fi'
# https://spin.atomicobject.com/2016/05/28/log-bash-history/ - END

#http://stackoverflow.com/a/19616645/274677
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
alias x='exit'
export PATH=$PATH:~/local-tools:~/local-tools-sensitive
alias gs='git status -s'
alias gq='git add . -A -n'
alias ga='git add . -A'
alias gd='git diff --no-ext-diff'
alias gb='git branch'
alias gdd='git diff'
gcmF() {
    git commit -m "$*"
}
alias gcm=gcmF

# http://askubuntu.com/a/702773/89663
set-title() {
    ORIG=$PS1
    TITLE="\e]2;$@\a"
    PS1=${ORIG}${TITLE}
}
export PATH=$PATH:$HOME/.local/bin


# it turned out that the below was more trouble than was worth it
# --%<---------------------------------------------------------------------------------------------
# https://askubuntu.com/a/6703/89663
# requires: sudo apt-get install trash-cli
# https://github.com/andreafrancia/trash-cli
# alias rm='echo "This is not the command you are looking for. Use either \rm or trash-put"; false'
# --------------------------------------------------------------------------------------------->%--
