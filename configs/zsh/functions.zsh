#===============================================================================
# icl - interactive command library 
#===============================================================================

f_run_icl(){
    icl_OUTPUT=$(icl)
    print -z $icl_OUTPUT
    zle accept-line # no idea if this is the way it's done
}

zle -N w_run_icl f_run_icl # create a widget
bindkey ^t w_run_icl

#===============================================================================
# END  icl - interactive command library END
#===============================================================================
#
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

function http_what() {
    case $1 in
      100) echo "Continue                      " ;;
      101) echo "Switching Protocols           " ;;
      200) echo "OK                            " ;;
      201) echo "Created                       " ;;
      202) echo "Accepted                      " ;;
      203) echo "Non-Authoritative Information " ;;
      204) echo "No Content                    " ;;
      205) echo "Reset Content                 " ;;
      206) echo "Partial Content               " ;;
      300) echo "Multiple Choices              " ;;
      301) echo "Moved Permanently             " ;;
      302) echo "Found                         " ;;
      303) echo "See Other                     " ;;
      304) echo "Not Modified                  " ;;
      305) echo "Use Proxy                     " ;;
      307) echo "Temporary Redirect            " ;;
      400) echo "Bad Request                   " ;;
      401) echo "Unauthorized                  " ;;
      402) echo "Payment Required              " ;;
      403) echo "Forbidden                     " ;;
      404) echo "Not Found                     " ;;
      405) echo "Method Not Allowed            " ;;
      406) echo "Not Acceptable                " ;;
      407) echo "Proxy Authentication Required " ;;
      408) echo "Request Timeout               " ;;
      409) echo "Conflict                      " ;;
      410) echo "Gone                          " ;;
      411) echo "Length Required               " ;;
      412) echo "Precondition Failed           " ;;
      413) echo "Payload Too Large             " ;;
      414) echo "URI Too Long                  " ;;
      415) echo "Unsupported Media Type        " ;;
      416) echo "Range Not Satisfiable         " ;;
      417) echo "Expectation Failed            " ;;
      426) echo "Upgrade Required              " ;;
      500) echo "Internal Server Error         " ;;
      501) echo "Not Implemented               " ;;
      502) echo "Bad Gateway                   " ;;
      503) echo "Service Unavailable           " ;;
      504) echo "Gateway Timeout               " ;;
      505) echo "HTTP Version Not Supported    " ;;
    esac
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

cleantex () {
    find . \( -name '*.aux' -o -name '*.log' -o -name '*.toc' -o -name '*.out' \) -ok rm '{}' ';'
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

# shadows system ssh to start tmux sessions. Will be revised when I
# eventually hit a server without tmux installed
ssht() {
    /usr/bin/ssh -t $@ "tmux attach || tmux new";
}

man(){
        env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
}

function lb() {
    # from https://routley.io/tech/2017/11/23/logbook.html
    vim ~/logbook/$(date '+%Y-%m-%d').md
}

