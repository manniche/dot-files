# Currently this path is appendend to dynamically when picking a ruby version
export PATH=$PATH:/opt/bin/
export PATH=$PATH:/snap/bin/
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/share/python/
export PATH=$PATH:/sbin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/local/bin
export PATH=$PATH:$HOME/bin/
export PATH=$PATH:$HOME/.emacs.d/bin/
export PATH=$PATH:$HOME/opt/bin

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

# Setup terminal, and turn on colors
export CLICOLOR=1

# This resolves issues install the mysql, postgres, and other gems with native non universal binary extensions
export ARCHFLAGS='-arch x86_64'

export LESS='--ignore-case --raw-control-chars'
export PAGER='less'

export EMAIL="steen@manniche.net"
export EDITOR=vim #"$(if [[ -n $DISPLAY ]]; then echo 'ec'; else echo 'vim'; fi)"
export VISUAL=$EDITOR
export SVN_EDITOR=$EDITOR
export GIT_EDITOR='vim'
export BROWSER=firefox
export TERMINAL=lxterminal

export NLS_LANG="AMERICAN_AMERICA.UTF8"
export PATH=$PATH:$LD_LIBRARY_PATH

# experiments
export LANGUAGE=EN_us
export LC_ALL="en_US.utf8"
export LANG="en_US.UTF-8"

#virtualenv
export WORKON_HOME=~/.virtualenvs

# for nnn
export NNN_FALLBACK_OPENER=xdg-open
export NNN_RESTRICT_NAV_OPEN=1
# go
export GOPATH=$HOME/.go

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/entwicklung

export REVIEW_BASE=master
