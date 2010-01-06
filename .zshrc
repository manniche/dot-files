# The following lines were added by compinstall

zstyle :compinstall filename '/home/stm/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt extended_history     # save each command's beginning timestamp and the duration to the history file

setopt appendhistory autocd extendedglob notify
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

# don't send hang-up to running jobs when quitting (use screen)
setopt NO_HUP

# correct first token on line
setopt CORRECT

setopt AUTO_PUSHD

##  --- Disable shell timeout
unset TMOUT

# Print out current calendar with highlighted day
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

alias cal=calendar

# Remove useless files
clean () {
    if [ "$1" = "-r" ]; then
	find . \( -name '#*' -o -name '*~' -o -name '.*~' -o -name 'core*' \
	              -o -name 'dead*' \) -ok rm '{}' ';'
    else
	rm -i \#* *~ .*~ core* dead*
    fi
}

# Extract most types of archive
extract() {
   if [[ -z "$1" ]]; then
      print -P "usage: \e[1;36mextract\e[1;0m < filename >"
      print -P "       Extract the file specified based on the extension"
   elif [[ -f $1 ]]; then
      case ${(L)1} in
	  *.tar.bz2)  tar -jxvf $1;;
	  *.tar.gz)   tar -zxvf $1;;
	  *.bz2)      bunzip2 $1   ;;
	  *.gz)       gunzip $1   ;;
	  *.jar)      unzip $1       ;;
	  *.rar)      unrar x $1   ;;
	  *.tar)      tar -xvf $1   ;;
	  *.tbz2)     tar -jxvf $1;;
	  *.tgz)      tar -zxvf $1;;
	  *.zip)      unzip $1      ;;
	  *.Z)        uncompress $1;;
         *)          echo "Unable to extract '$1' :: Unknown extension"
      esac
   else
      echo "File ('$1') does not exist!"
   fi
}

#mkdir and go into it
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

# SEARCH: summarized google, ggogle, mggogle, agoogle and fm
search()
{
  case "$1" in
    -g) ${BROWSER:-lynx} http://www.google.com/search\?q=$2
    ;;
    -u) ${BROWSER:-lynx} http://groups.google.com/groups\?q=$2
    ;;
    -m) ${BROWSER:-lynx} http://groups.google.com/groups\?selm=$2
    ;;
    -a) ${BROWSER:-lynx} http://groups.google.com/groups\?as_uauthors=$2
    ;;
    -c) ${BROWSER:-lynx} http://search.cpan.org/search\?query=$2\&mode=module
    ;;
    -f) ${BROWSER:-lynx} http://freshmeat.net/search/\?q=$2\&section=projects
    ;;
    -F) ${BROWSER:-lynx} http://www.filewatcher.com/\?q=$2
    ;;
    -G) ${BROWSER:-lynx} http://www.rommel.stw.uni-erlangen.de/~fejf/cgi-bin/pfs-web.pl\?filter-search_file=$2
    ;;
    -s) ${BROWSER:-lynx} http://sourceforge.net/search/\?type=soft\&q=$2
    ;;
    -w) ${BROWSER:-lynx} http://de.wikipedia.org/wiki/$2
    ;;
    -W) ${BROWSER:-lynx} http://en.wikipedia.org/wiki/$2
    ;;
    -d) lynx -source "http://dict.leo.org?$2" | grep -i "TABLE.*/TABLE" | sed "s/^.*\(<TABLE.*TABLE>\).*$/<HTML><BODY>\1<\/BODY><\/HTML>/" | lynx -stdin -dump -width=$COLUMNS -nolist;
    ;;
    *) 
      echo "Usage: $0 {-g | -u | -m | -a | -f | -c | -F | -s | -w | -W | -d}"
      echo "  -g:  Searching for keyword in google.com"
      echo "  -u:  Searching for keyword in groups.google.com"
      echo "  -m:  Searching for message-id in groups.google.com"
      echo "  -a:  Searching for Authors in groups.google.com"
      echo "  -c:  Searching for Modules on cpan.org."
      echo "  -f:  Searching for projects on Freshmeat."
      echo "  -F:  Searching for packages on FileWatcher."
      echo "  -G:  Gentoo file search."
      echo "  -s:  Searching for software on Sourceforge."
      echo "  -w:  Searching for keyword at wikipedia (german)."
      echo "  -W:  Searching for keyword at wikipedia (english)."
      echo "  -d:  Query dict.leo.org ;)"
  esac
}

compctl -g '*.tar.bz2 *.tar.gz *.bz2 *.gz *.jar *.rar *.tar *.tbz2 *.tgz *.zip *.Z' + -g '*(-/)' extract

# Create a diff
mdiff() { diff -udrP "$1" "$2" > diff.$(date "+%Y-%m-%d")."$1" }

# Reset current directory to sensible permissions
saneperms() {
    find . -type d -print0 | xargs -0 chmod 755
    find . -type f -print0 | xargs -0 chmod 644
}

# give all files in directory executable status
execperms(){
    find . -type d -print0 | xargs -0 chmod 755
    find . -type f -print0 | xargs -0 chmod 755
}

setWindowTitle(){
    echo -ne "\e]2;$*\a"
}

updateWindowTitle() {
    setWindowTitle "$USER@$HOST:$PWD/"
}

precmd () { updateWindowTitle }

command_title () {
    ### this function sets the current command name in title bars, tabs, and screen lists
    ## inspired by: http://www.semicomplete.com/blog/2006/Jun/29
    if [[ -n ${SHELL_NAME} ]]
    then
        # allow the $cmnd_name to be set manually and override automatic values
        # to set the shell's title to "foo";    export SHELL_NAME=foo
        # to return to normal operation;        unset SHELL_NAME
        cmnd_name="${SHELL_NAME}"
    elif [[ 'fg' == "${${(z)@}[1]}" ]]
    then
        # this is a poor hack to replace 'fg' with a more sensical command
        # it really only works properly if only one job is suspended
        cmnd_name="${(vV)jobtexts}"
    else
        # get the $cmnd_name from the current command being executed
        # make nonprintables visible
        local cmnd_name="${(V)1}"
    fi
    # escape '%'; get rid of pesky newlines; get rid of tabs; instruct the prompt to truncate
    cmnd_name="%80>...>${${${cmnd_name//\%/\%\%}//'\n'/; }//'\t'/ }%<<"
    # ^^^ in other words:
    # ${cmnd_name//\%/\%\%} ; ${cmnd_name}//'\n'/; } ; ${cmnd_name//'\t'/ } ; %60>...>${cmnd_name}%<<
    # if the shell is not run by the $LOGIN user, prefix the command with "$USERNAME: "
    [[ "${USERNAME}" != "${LOGNAME}" ]] && cmnd_name="${USERNAME}: ${cmnd_name}"
    # if the shell is running on an ssh connection, prefix the command with "$HOST: "
    [[ -n "${SSH_CONNECTION}" ]] && cmnd_name="${HOST}: ${cmnd_name}"
    # don't confuse the display any more than required
    #   we'll put this back, if required, below
    unsetopt PROMPT_SUBST
    case ${TERM} {
    xterm*)
        print -Pn "\e]0;[xterm] ${cmnd_name}\a" # plain xterm title & icon name
        ;;
    screen)
        print -Pn "\ek${cmnd_name}\e\\" # screen title
        ;;
    rxvt*)
        print -Pn "\e]62;[mrxvt] ${cmnd_name}\a" # rxvt title name
        [[ -n ${MRXVT_TABTITLE} || -n ${SSH_CONNECTION} ]] && \
            print -Pn "\e]61;${cmnd_name}\a" # mrxvt tab name
            ## using ssh from *rxvt, we'll assume that it's mrxvt
            ## there's no good way to know for sure
            ## this doesn't seem to cause any harm
        ;;
    }
    # return PROMPT_SUBST to previous state, if it was set
    setopt LOCAL_OPTIONS
}

alias lll='ls -ahl --color | more; echo "\e[1;32m --[\e[1;34m Dirs:\e[1;36m `ls -al | egrep \"^drw\" | wc -l` \e[1;32m|\e[1;35m Files: \e[1;31m`ls -al | egrep -v \"^drw\" | grep -v total | wc -l` \e[1;32m]--"'

alias ll='ls -la --color=auto'
alias l='ls -l --color=auto'
alias gtd='emacs -f gtd'
alias lesshtml='/usr/bin/w3m -dump -T text/html'

alias pm-suspend='pm-suspend'
alias suspend='sudo pm-suspend'

bindkey -s "^x^f" $'emacs '

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

for k in ${(k)key} ; do
    # $terminfo[] entries are weird in ncurses application mode...
    [[ ${key[$k]} == $'\eO'* ]] && key[$k]=${key[$k]/O/[}
done
unset k

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char





#from http://jaderholm.com/configs/zshrc
# Global Aliases
alias -g L='|less'
alias -g M='|more'
alias -g G='|grep'
alias -g T='|tail -f'
alias -g H='|head -n 20'
alias -g W='|wc -l'
alias -g S='|sort'

alias -g has='ps aux | grep '

# filter out */.svn* when doing find, svn status etc.
alias -g NOSVN='| egrep -v "*\.svn"'

alias -g mybugs='buglist opensearch | grep " stm "'


LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:';
export LS_COLORS


# the big tab completion game:
# Completion, color
#zstyle ':completion:*' completer _complete
autoload -U compinit
compinit
ZLS_COLORS=$LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}


zstyle ':completion:*' list-colors no=00 fi=00 di=01\;34 pi=33 so=01\;35 bd=00\;35 cd=00\;34 or=00\;41 mi=00\;45 ex=01\;32

### Enable advanced completions
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

### General completion technique
zstyle ':completion:*' completer _complete _correct _approximate _prefix
#zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

# Completion caching
# zstyle ':completion::complete:*' use-cache 1
# zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'
# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# Separate matches into groups
# zstyle ':completion:*:matches' group 'yes'

# # Describe each match group.
# zstyle ':completion:*:descriptions' format "%B---- %d%b"

# # Messages/warnings format
# zstyle ':completion:*:messages' format '%B%U---- %d%u%b' 
# zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'
 
# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# menu for kill
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# kill menu extension!
zstyle ':completion:*:processes' command 'ps --forest -U $(whoami) | sed "/ps/d"'
#zstyle ':completion:*:processes' command 'ps -U $(whoami) | sed "/ps/d"'

#zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes' insert-ids menu yes select
# case insensitivity, partial matching, substitution
zstyle ':completion:*' matcher-list 'm:{A-Z}={a-z}' 'm:{a-z}={A-Z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'

# remove uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
   adm alias apache at bin cron cyrus daemon ftp games gdm guest \
   haldaemon halt mail man messagebus mysql named news nobody nut \
   lp operator portage postfix postgres postmaster qmaild qmaill \
   qmailp qmailq qmailr qmails shutdown smmsp squid sshd sync \
   uucp vpopmail xfs

# zstyle ':completion:*' hosts $ssh_hosts

zstyle ':completion:*:my-accounts' users-hosts $my_accounts
zstyle ':completion:*:other-accounts' users-hosts $other_accounts

