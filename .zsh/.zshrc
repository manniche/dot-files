# Load vcs_info so precmd can utilize it
# autoload -Uz vcs_info

source ~/.zsh/colors.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/exports.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/completion.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/bindkeys.zsh
source ~/.zsh/functions.zsh
source ~/.zsh/history.zsh
source ~/.zsh/zsh_hooks.zsh

fpath=(/home/semn/.zsh/zsh_completions $fpath)
#source ~/.rvm/scripts/rvm 

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 

for i in /etc/novoenv.d/*.sh; do
    if [ -r "$i" ]; then
        . $i
    fi
done
