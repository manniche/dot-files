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

fpath=(/home/s/.zsh/zsh_completions $fpath)
#source ~/.rvm/scripts/rvm 

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
