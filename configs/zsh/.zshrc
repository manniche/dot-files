# Load vcs_info so precmd can utilize it
# autoload -Uz vcs_info
[ $TERM = "dumb" ] && unsetopt zle && PS1='$ ' # Hi Tramp!

# Attach to existing tmux session if one exists, otherwise create a new one
#[ -z "$TMUX" ] && exec tmux attach || exec tmux

source ~/.zsh/colors.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/exports.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/completion.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/bindkeys.zsh
source ~/.zsh/functions.zsh
source ~/.zsh/history.zsh
source ~/.zsh/sgpt.zsh
source ~/.zsh/tmux-notify.zsh

# Launch SSH agent if not running
if ! ps aux |grep $(whoami) |grep ssh-agent |grep -v grep >/dev/null; then ssh-agent ; fi

# Link the latest ssh-agent socket
#ln -sf $(find /tmp -maxdepth 2 -type s -name "agent*" -user $USER -printf '%T@ %p\n' 2>/dev/null |sort -n|tail -1|cut -d' ' -f2) ~/.ssh/ssh_auth_sock

# Created by `userpath` on 2019-12-18 10:21:42
#POWERLEVEL9K_MODE='awesome-fontconfig'
#source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme
#source  ~/powerlevel9k/powerlevel9k.zsh-theme

source /usr/local/bin/virtualenvwrapper.sh

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(uv generate-shell-completion zsh)"

# Scaleway CLI autocomplete initialization.
eval "$(scw autocomplete script shell=zsh)"

# opencode
export PATH=/home/steen/.opencode/bin:$PATH

. "$HOME/.moon/bin/env"
