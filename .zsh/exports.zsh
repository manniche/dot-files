# Adding clojure home
export CLOJURE_HOME=~/.cljr/bin

# Currently this path is appendend to dynamically when picking a ruby version
export PATH=/usr/local/sbin:/usr/local/bin:/usr/local/share/python/:/sbin:$HOME/local/bin:$CLOJURE_HOME:/opt/sqldeveloper:/usr/lib/rstudio/bin/:~/bin/:$PATH

# Our list of directories we can cd to from anywhere
export CDPATH=.:~/entwicklung/

# Set default console Java to 1.6
export JAVA_HOME=/opt/jdk1.7/

# Setup terminal, and turn on colors
export CLICOLOR=1
#export LSCOLORS=Gxfxcxdxbxegedabagacad

# Enable color in grep
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='3;33'

# This resolves issues install the mysql, postgres, and other gems with native non universal binary extensions
export ARCHFLAGS='-arch x86_64'

export LESS='--ignore-case --raw-control-chars'
export PAGER='less'

#make less read archive files:
export LESSOPEN="| /usr/bin/lesspipe %s"
export LESSCLOSE="/usr/bin/lesspipe %s %s"

export NODE_PATH=/usr/local/lib/node
export PYTHONPATH=/usr/local/lib/python2.6/site-packages

export EMAIL="steen@manniche.net"
export EDITOR=emacs
export VISUAL=emacs
export SVN_EDITOR=emacsclient
export GIT_EDITOR=emacsclient
export BROWSER=firefox
export TERMINAL=roxterm
export TERM=xterm-256color

export LD_LIBRARY_PATH=/opt/oracle/instantclient_11_2
export SQLPATH="/opt/oracle/instantclient_11_2"
#export TNS_ADMIN="/usr/local/oracle/network/admin"
export NLS_LANG="AMERICAN_AMERICA.UTF8"
export PATH=$PATH:$LD_LIBRARY_PATH

# experiments
export LANGUAGE=EN_us
export LC_ALL="en_US.utf8"
export LANG="EN_us.UTF-8"

#virtualenv
export WORKON_HOME=~/.virtualenvs

source ~/.zsh/.oracleenv
