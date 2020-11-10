# Load vcs_info so precmd can utilize it
# autoload -Uz vcs_info
[ $TERM = "dumb" ] && unsetopt zle && PS1='$ ' # Hi Tramp!

if [ -d /etc/novoenv.d ]
then
    source ~/.zsh/novoenv.zsh
fi
source ~/.zsh/colors.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/exports.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/completion.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/bindkeys.zsh
source ~/.zsh/functions.zsh
source ~/.zsh/history.zsh

autoload -U promptinit; promptinit
prompt spaceship

# Launch SSH agent if not running
if ! ps aux |grep $(whoami) |grep ssh-agent |grep -v grep >/dev/null; then ssh-agent ; fi

# Link the latest ssh-agent socket
ln -sf $(find /tmp -maxdepth 2 -type s -name "agent*" -user $USER -printf '%T@ %p\n' 2>/dev/null |sort -n|tail -1|cut -d' ' -f2) ~/.ssh/ssh_auth_sock

export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

# Created by `userpath` on 2019-12-18 10:21:42
export PATH="$PATH:/home/manniche/.local/bin"
POWERLEVEL9K_MODE='awesome-fontconfig'
#source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme
#source  ~/powerlevel9k/powerlevel9k.zsh-theme

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
