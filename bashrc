###
# Generally created by Corry Haines (tabletcorry@gmail.com)
###

if [ -f /usr/local/etc/bash_completion ]; then
  # Probably using Homebrew
  . /usr/local/etc/bash_completion
elif [ -f /opt/local/etc/bash_completion ]; then
  # Probably using Macports
	. /opt/local/etc/bash_completion
elif [ -f /etc/bash_completion ]; then
  # Probably a normal system
	. /etc/bash_completion
fi

# The __git_ps1 function is really good. Only use homegrown if it is missing
if __git_ps1 2>/dev/null
then
  # Turn on all of the __git_ps1 features
  export GIT_PS1_SHOWDIRTYSTATE=1
  export GIT_PS1_SHOWSTASHSTATE=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  export GIT_PS1_SHOWUPSTREAM="auto verbose"
  function gitb_time {
    echo "$(__git_ps1)  $(date +%T)"
  }
else
  # __git_ps1 is for some reason not present so use my crappy version
  function git_branch {
    ref=$(git symbolic-ref HEAD) || return
    git diff-files --quiet && dirty="@" || dirty="*"
    echo "$dirty["${ref#refs/heads/}"]"
  } 2>/dev/null

  function gitb_time {
    echo "$(git_branch 2>/dev/null)  $(date +%T)"
  }
fi

function virtualenv_name {
  if [ -n "$VIRTUAL_ENV" ]; then
    echo " ($(basename $VIRTUAL_ENV))"
  fi
}

# Yep, this is a two line prompt (though it may not be obvious). Format follows:
# Path                                         ($?) (virtualenv) (git info) Time
# Prompt-char
export PS1='$(printf "%${COLUMNS}s" "($?)$(virtualenv_name)$(gitb_time 2>/dev/null)")\r\u@\h:\W \n\$ '

# I like bash 4 features
if [ $BASH_VERSINFO -eq 4 ]; then
	shopt -s autocd
	shopt -s checkjobs
	shopt -s dirspell
	shopt -s globstar
fi

# I assume that I have at least bash 3
shopt -s cdable_vars
shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s extglob
shopt -s histappend

case $OSTYPE in
	darwin* ) # Alias for BSD type tools
    ON_MAC=true

    # Create a status keystroke for ping and the like
    stty status ^T

    # gitk looks terrible on mac, use wish to prettify it
    alias gitk="/usr/bin/wish $(which gitk)"

    export ARCHFLAGS='-arch x86_64'

    # Get a core count to pass to make
		core_count=`sysctl -n hw.ncpu`

    # BSD ls is different... of course
		ls_opts="-GF"
    if [ -e "/usr/local/bin/gls" ]; then
		  ls_opts="--color=auto -F"
      ls_bin="/usr/local/bin/gls"
    else
      ls_bin="ls"
    fi
		;;
	linux* ) # Alias for GNU style tools
    # Some OS's do not give sbin to normal users (CENTOS!)
		export PATH=/sbin:/usr/sbin:$PATH

		core_count=`grep siblings /proc/cpuinfo | sort -u | \
			sed 's/[^0-9]\+\([0-9]\+\)/\1/'`
		ls_opts="--color=auto -F"
    ls_bin="ls"
		;;
	* ) echo *** Bash Profile unable to recognize OS type: $OSTYPE ***;;
esac

# Bunches of aliases for typos and shortcuts

alias l="$ls_bin $ls_opts"
alias ll="$ls_bin -l $ls_opts"
alias ls="$ls_bin $ls_opts"
alias make="make -sj$((core_count+1))"
alias grep="grep --color=auto"

alias gits='git status'
alias gitr='git svn fetch && git svn rebase'
alias gvn='git svn dcommit'
alias gitt="git log --graph --format=oneline --abbrev-commit --decorate"
alias gti="git"
alias gtis="git status"
alias gitu="git fetch && git merge --ff-only @{u}"

alias mc=mv
alias vp=cp
alias bim=vim
alias vom=vim
alias cim=vim
alias bit=git
alias cit=git
alias pint=ping
alias pign=ping


alias dc='cd'
alias cd..='cd ..'
alias dc..='cd ..'

# One can never have enough history
export HISTCONTROL=ignoreboth
export HISTFILESIZE=100000000
export HISTSIZE=1048576
export SAVEHIST=$HISTSIZE
HISTIGNORE='fg:bg:ls:pwd:cd:cd..:cd ..:jobs:ls -l:ls -lah'
HISTIGNORE="$HISTIGNORE:du -csh:df -h:exit:rm *:rm -r *:sudo rm *"
export HISTIGNORE

export EDITOR=vim
export SVN_EDITOR=$EDITOR
export PAGER=less

export MAVEN_OPTS="-Dmaven.artifact.threads=$core_count -Xmx756m"

if [ -e "~/.bashrc.rfi" ]; then
  # source some work stuff
  source ~/.bashrc.rfi
fi

# Bring the Homebrew binaries in
export PATH="/usr/local/sbin:/usr/local/bin:$PATH"
export PATH="/usr/local/share/python:$PATH"

if [ -f "$HOME/.pythonrc.py" ]
then
  export PYTHONSTARTUP=$HOME/.pythonrc.py
fi

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end

# virtualenv stuff
export PIP_REQUIRE_VIRTUALENV=true
export VIRTUAL_ENV_DISABLE_PROMPT=true

# virtualenvwwrapper stuff
export WORKON_HOME=$HOME/.virtualenvs
if [ ! -e "$WORKON_HOME" ]; then
  mkdir -p $WORKON_HOME
fi
source /usr/local/bin/virtualenvwrapper.sh
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'

export PIP_VIRTUALENV_BASE=$WORKON_HOME

has_virtualenv() {
  if [ -e .venv ]; then
    if [ -z "$VIRTUAL_ENV" ]; then
      workon `cat .venv`
    fi
  fi
}
venv_cd () {
  cd "$@" && has_virtualenv
}
alias cd="venv_cd"

export HOMEBREW_BUILD_FROM_SOURCE=true
