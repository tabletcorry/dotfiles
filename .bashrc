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

# Yep, this is a two line prompt (though it may not be obvious). Format follows:
# Path                                                  ($?) (git info) Time
# Prompt-char
export PS1='$(printf "%${COLUMNS}s" "($?)$(gitb_time 2>/dev/null)")\r\u@\h:\W \n\$ '

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

if [ -f ~/.profile ]; then
	. ~/.profile
fi

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
		;;
	linux* ) # Alias for GNU style tools
    # Some OS's do not give sbin to normal users (CENTOS!)
		export PATH=/sbin:/usr/sbin:$PATH

		core_count=`grep siblings /proc/cpuinfo | sort -u | \
			sed 's/[^0-9]\+\([0-9]\+\)/\1/'`
		ls_opts="--color=auto -F"
		;;
	* ) echo *** Bash Profile unable to recognize OS type: $OSTYPE ***;;
esac

# Bunches of aliases for typos and shortcuts

alias l="ls $ls_opts"
alias ls="ls $ls_opts"
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

export MAVEN_OPTS='-Dmaven.artifact.threads=4 -Xmx756m'

# source some work stuff
source ~/.bashrc.rfi

git-patch-single() {
  git diff $1^..$1
}

# Bring the Homebrew binaries in
export PATH="/usr/local/bin:$PATH"
