## This file is sourced by all *interactive* bash shells on startup.  This
## file *should generate no output* or it will break the scp and rcp commands.
############################################################

if [ -e /etc/bashrc ] ; then
  . /etc/bashrc
fi

############################################################
## PATH
############################################################

function conditionally_prefix_path {
  local dir=$1
  if [ -d $dir ]; then
    PATH="$dir:${PATH}"
  fi
}

conditionally_prefix_path /usr/local/bin
conditionally_prefix_path /usr/local/sbin
conditionally_prefix_path /usr/local/share/python
conditionally_prefix_path /usr/local/share/npm/bin
conditionally_prefix_path /usr/local/mysql/bin
conditionally_prefix_path /usr/local/heroku/bin
conditionally_prefix_path /usr/texbin
conditionally_prefix_path ~/bin
conditionally_prefix_path ~/bin/private
conditionally_prefix_path ~/android/sdk-tool # For android command
conditionally_prefix_path ~/.pyenv/shims

PATH=.:./bin:${PATH}

############################################################
## MANPATH
############################################################

function conditionally_prefix_manpath {
  local dir=$1
  if [ -d $dir ]; then
    MANPATH="$dir:${MANPATH}"
  fi
}

conditionally_prefix_manpath /usr/local/man
conditionally_prefix_manpath ~/man

############################################################
## Other paths
############################################################

function conditionally_prefix_cdpath {
  local dir=$1
  if [ -d $dir ]; then
    CDPATH="$dir:${CDPATH}"
  fi
}

conditionally_prefix_cdpath ~/work

CDPATH=.:${CDPATH}

# Set INFOPATH so it includes users' private info if it exists
# if [ -d ~/info ]; then
#   INFOPATH="~/info:${INFOPATH}"
# fi

############################################################
## General development configurations
###########################################################

if [ `which rbenv 2> /dev/null` ]; then
  eval "$(rbenv init -)"
fi

if [ -f ~/.nvm/nvm.sh ]; then
  . ~/.nvm/nvm.sh
fi

############################################################
## Terminal behavior
############################################################

# Set window titles for screens
stty ixany
stty ixoff -ixon
#if [ "$TERM" = "screen" ]; then
  screen_set_window_title () {
    local HPWD="$PWD"
    case $HPWD in
      $HOME) HPWD="~";;
      $HOME/*) HPWD="~${HPWD#$HOME}";;
    esac
    printf '\ek%s\e\\' "$HPWD"
  }

# Text color variables for prompt command colors
txtred="\[\033[31m\]"    # Red
txtgrn="\[\033[32m\]"    # Green
txtylw="\[\033[33m\]"    # Yellow
txtpur="\[\033[35m\]"    # Purple
txtcyn="\[\033[36m\]"    # Cyan
txtrst="\[\033[0m\]"     # Text reset

# Set colorful prompt command with return value information
# Prompt will look like: ~[0] paulfoster@Pauls-MacBook-Pro:/Users/paulfoster
export PROMPT_COMMAND="export retval=\$?; if (( \$retval )) ; then PS1=\"[$txtred\$retval${txtrst}] ${txtcyn}\u${txtrst}@${txtpur}\h${txtrst}:${txtylw}\$PWD${txtrst}\n$ \"; else PS1=\"[$txtgrn\$retval${txtrst}] ${txtcyn}\u${txtrst}@${txtpur}\h${txtrst}:${txtylw}\$PWD${txtrst}\n$ \"; fi; screen_set_window_title;"

# Show the git branch and dirty state in the prompt.
# Borrowed from: http://henrik.nyh.se/2008/12/git-dirty-prompt
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

if [ `which git 2> /dev/null` ]; then
  function git_prompt {
    parse_git_branch
  }
else
  function git_prompt {
    echo ""
  }
fi

if [ `which rbenv 2> /dev/null` ]; then
  function ruby_prompt {
    echo $(rbenv version-name)
  }
elif [ `which ruby 2> /dev/null` ]; then
  function ruby_prompt {
    echo $(ruby --version | cut -d' ' -f2)
  }
else
  function ruby_prompt {
    echo ""
  }
fi

if [ `which rbenv-gemset 2> /dev/null` ]; then
  function gemset_prompt {
    local gemset=$(rbenv gemset active 2> /dev/null)
    if [ $gemset ]; then
      echo " ${gemset}"
    fi
  }
else
  function gemset_prompt {
    echo ""
  }
fi

if [ -n "$BASH" ]; then
  export PS1='\[\033[32m\]\n[\s: \w] ($(ruby_prompt)$(gemset_prompt)) $(git_prompt)\n\[\033[31m\][\u@\h]\$ \[\033[00m\]'
fi

############################################################
## Optional shell behavior
############################################################

shopt -s cdspell
shopt -s extglob
shopt -s checkwinsize

export PAGER="less"
export EDITOR="emacsclient"

############################################################
## History
############################################################

# When you exit a shell, the history from that session is appended to
# ~/.bash_history.  Without this, you might very well lose the history of entire
# sessions (weird that this is not enabled by default).
shopt -s histappend

export HISTIGNORE="&:pwd:ls:ll:lal:[bf]g:exit:rm*:sudo rm*"
# remove duplicates from the history (when a new item is added)
export HISTCONTROL=erasedups
# increase the default size from only 1,000 items
export HISTSIZE=10000

############################################################
## Aliases
############################################################

if [ -e ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

############################################################
## Bash Completion, if available
############################################################

if [ -f /usr/local/etc/bash_completion ]; then
  . /usr/local/etc/bash_completion
elif  [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
elif  [ -f /etc/profile.d/bash_completion ]; then
  . /etc/profile.d/bash_completion
elif [ -e ~/.bash_completion ]; then
  # Fallback. This should be sourced by the above scripts.
  . ~/.bash_completion
fi

############################################################
## Other
############################################################

if [[ "$USER" == '' ]]; then
  # mainly for cygwin terminals. set USER env var if not already set
  USER=$USERNAME
fi

############################################################
## Bashmarks
############################################################

if [ -e ~/.local/bin/bashmarks.sh ] ; then
  . ~/.local/bin/bashmarks.sh
fi

############################################################
## EXPORTED VARIABLES
############################################################

export ANDROID_NDK=/Users/paulfoster/android/android-ndk-r8e
export ANDROID_HOME=~/android/sdk
export ANDROID_SDK_ROOT=~/android/sdk
export PATH=~/android/sdk/tools:~/android/sdk/platform-tools:${PATH} # For android command
# FIXME: Attempt to get maven to work with compiling apks via playn
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_60.jdk
# I found this using /usr/libexec/java_home
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_60.jdk/Contents/Home
