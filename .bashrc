# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=100000
PROMPT_COMMAND='history -a'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \[\033[31m\]\`ruby -e \"print (%x{git branch 2> /dev/null}.split(%r{\n}).grep(/^\*/).first || '').gsub(/^\* (.+)$/, '(\1) ')\"\`\[\033[30m\]$\[\033[00m\] "

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias g='git'
source /usr/share/bash-completion/completions/git
__git_complete g __git_main
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias watch='watch --color -n 0.1'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PATH=~/.cargo/bin:$PATH

alias c='code .'
alias n='ninja -C build'
alias ninjalgolia='ninja -j1 -C build geoip && ninja -j10 -C build'

alias update='sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade && sudo apt autoremove && sudo apt autoclean '

alias refull='rerelease ; redebug ; resanitize'
alias rerelease='cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -GNinja && ninjalgolia'
alias redebug='cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -GNinja && ninjalgolia'
alias redefault='cmake -H. -Bbuild -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -GNinja && ninjalgolia'
alias resanitize='cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=Sanitize -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -GNinja && ninjalgolia'
alias full='release ; debug ; sanitize'
alias release='ninjalgolia'
alias debug='ninjalgolia'
alias default='ninjalgolia'
alias sanitize='ninjalgolia'

# For DUO access
export AUSER=jvalette

# To add silversearcher's colors to ripgrep
alias rg='rg --colors line:fg:yellow --colors line:style:bold --colors path:fg:green --colors path:style:bold --colors match:fg:black --colors match:bg:yellow --colors match:style:nobold'

eval $(thefuck --alias)

export PATH="$HOME/.cabal/bin:$PATH"

export MAIL=joris.valette@algolia.com

# For deployment
export VAULT_ADDR=https://vault-elb.algolia.net:8200
export VAULT_USERNAME="joris.valette"
export VAULT_PASSWORD="hidden"
export VAULT_TOKEN=$(vault token lookup | grep -E '^id' | rev | cut -d' ' -f1 | rev)
# If I need to login into vault again, I need to use this:
# vault login -method=userpass username=$VAULT_USERNAME password=$VAULT_PASSWORD

# For Github
export GITHUB_USER=jojva
export GITHUB_USER_TOKEN=hidden
export CONFLUENCE_TOKEN=hidden

eval "$(starship init bash)"

# For Trello and multimarkdown
export PATH="$HOME/bin:$PATH"

# For p4merge
export PATH="/usr/local/bin:$PATH"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
