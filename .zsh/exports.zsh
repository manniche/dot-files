# Currently this path is appendend to dynamically when picking a ruby version
export PATH=~/.bin:/usr/local/sbin:/usr/local/bin:/usr/local/share/npm/bin:/sbin:$HOME/local/bin:/opt/bin:$PATH

# Our list of directories we can cd to from anywhere
export CDPATH=.:~/entwicklung/

# Set default console Java to 1.6
export JAVA_HOME=/usr/lib/jvm/java-6-sun

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
export VISUAL=$EDITOR
export SVN_EDITOR=semacs
export GIT_EDITOR=semacs
export BROWSER=google-chrome

export GRAILS_HOME=~/local/grails-2.0.0