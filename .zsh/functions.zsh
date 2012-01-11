function zsh_recompile {
  autoload -U zrecompile

  [[ -f ~/.zshrc ]] && zrecompile -p ~/.zshrc
  [[ -f ~/.zshrc.zwc.old ]] && rm -f ~/.zshrc.zwc.old

  for f in ~/.zsh/**/*.zsh; do
    [[ -f $f ]] && zrecompile -p $f
    [[ -f $f.zwc.old ]] && rm -f $f.zwc.old
  done

  [[ -f ~/.zcompdump ]] && zrecompile -p ~/.zcompdump
  [[ -f ~/.zcompdump.zwc.old ]] && rm -f ~/.zcompdump.zwc.old

  source ~/.zshrc
}

function extract {
  echo Extracting $1 ...
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xjf $1  ;;
          *.tar.gz)    tar xzf $1  ;;
          *.bz2)       bunzip2 $1  ;;
          *.rar)       rar x $1    ;;
          *.gz)        gunzip $1   ;;
          *.tar)       tar xf $1   ;;
          *.tbz2)      tar xjf $1  ;;
          *.tgz)       tar xzf $1  ;;
          *.zip)       unzip $1   ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1  ;;
          *)        echo "'$1' cannot be extracted via extract()" ;;
      esac
  else
      echo "'$1' is not a valid file"
  fi
}

function pg_start {
  /usr/local/bin/pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
}

function pg_stop {
  /usr/local/bin/pg_ctl -D /usr/local/var/postgres stop -s -m fast
}

calendar() {
   if [[ ! -f /usr/bin/cal ]] ; then
      echo "Please install cal before trying to use it!"
      return
   fi

   if [[ "$#" = "0" ]] ; then
      /usr/bin/cal | egrep -C 40 --color "\<$(date +%e| tr -d ' ')\>"
   else
      /usr/bin/cal $@ | egrep -C 40 --color "\<($(date +%B)|$(date +%e | tr -d ' '))\>"
   fi
}

clean () {
    if [ "$1" = "-r" ]; then
        find . \( -name '#*' -o -name '*~' -o -name '.*~' -o -name 'core*' \
                      -o -name 'dead*' \) -ok rm '{}' ';'
    else
        rm -i \#* *~ .*~ core* dead*
    fi
}

mkcd() { 
    mkdir "$1" && cd "$1"; 
}
cpv () {
    ## verbose copy
    ## rsync, but neutered to only make local copies
    rsync -PIhb --backup-dir=/tmp/rsync -e /dev/null -- ${@}
}

hex2dec() { 
    awk 'BEGIN { printf "%d\n",0x$1}'; 
}
dec2hex() { awk 'BEGIN { printf "%x\n",$1}'; }

mktar() 
{ 
  if [ ! -z "$1" ]; then
    tar czf "${1%%/}.tar.gz" "${1%%/}/"; 
  else
    echo "Please specify a file or directory"
    exit 1
  fi
}

# sanitize - set file/directory owner and permissions to normal values (644/755)
# Usage: sanitize <file>
sanitize() {
    chmod -R u=rwX,go=rX "$@"
    chown -R ${USER}.users "$@"
}

# .. - Does a 'cd ..'
# .. 3 - Does a 'cd ../../..'
#
.. (){
  local arg=${1:-1};
  while [ $arg -gt 0 ]; do
    cd .. >&/dev/null;
    arg=$(($arg - 1));
  done
}




