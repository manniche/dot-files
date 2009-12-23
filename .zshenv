export JAVA_HOME=/opt/java/
export ANT_HOME=/usr/share/java/apache-ant/

export EMAIL="steen@manniche.net"
export EDITOR=emacs
export VISUAL=$EDITOR
export SVN_EDITOR=semacs
export BROWSER=firefox

export XTERM=xterm

#setting the correct timezone
export TZ="Europe/Copenhagen"

export CVSROOT=:pserver:stm@cvs.dbc.dk:/export/CVS

export CLASSPATH=/usr/local/lib/java:/usr/local/java/lib/junit4.jar:/usr/share/java/checkstyle-4.4.jar

export PLUGIN_HOME=/usr/lib/mozilla/plugins

export PERL5LIB=/home/stm/local/bin:/home/stm/local/tidsreg:/home/stm/local/lib

export PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$PATH:~/local/bin/:/opt/share/bin:/opt/bin

#this is important for mutt being able to display utf-8 correctly...
#export LC_CTYPE=
# well, apparently not...

#setting the MAIL env for mutt
export MAIL=~/Mail

# left prompt
export PROMPT="%# "
# right promt
export RPROMPT="[%D{%y%m%d-%H:%M}|%n@%m: %~]"
