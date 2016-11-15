# Adding clojure home
export CLOJURE_HOME=~/.cljr/bin

# Currently this path is appendend to dynamically when picking a ruby version
export PATH=/usr/local/sbin:/usr/local/bin:/usr/local/share/python/:/sbin:$HOME/local/bin:$HOME/opt/bin:/usr/lib/rstudio/bin/:~/bin/:$PATH

# Setup terminal, and turn on colors
export CLICOLOR=1

# This resolves issues install the mysql, postgres, and other gems with native non universal binary extensions
export ARCHFLAGS='-arch x86_64'

export LESS='--ignore-case --raw-control-chars'
export PAGER='less'

#make less read archive files:
export LESSOPEN="| /usr/bin/lesspipe %s"
export LESSCLOSE="/usr/bin/lesspipe %s %s"

export EMAIL="steen@manniche.net"
export EDITOR="emacs -nw -Q"
export VISUAL=$EDITOR
export SVN_EDITOR=$EDITOR
export GIT_EDITOR=$EDITOR
export BROWSER=firefox
export TERMINAL=terminator
#export TERM=xterm-256color

export NLS_LANG="AMERICAN_AMERICA.UTF8"
export PATH=$PATH:$LD_LIBRARY_PATH

# experiments
export LANGUAGE=EN_us
export LC_ALL="en_US.utf8"
export LANG="EN_us.UTF-8"

#virtualenv
export WORKON_HOME=~/.virtualenvs

export PYTHONSTARTUP=~/.pythonrc