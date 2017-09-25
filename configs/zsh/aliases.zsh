alias l='ls -alhF'
alias ll='ls -la -G --color=always'

alias lll='ls -ahl -G --color | more; echo "\e[1;32m --[\e[1;34m Dirs:\e[1;36m `ls -al | egrep \"^drw\" | wc -l` \e[1;32m|\e[1;35m Files: \e[1;31m`ls -al | egrep -v \"^drw\" | grep -v total | wc -l` \e[1;32m]--"'


alias mysql='mysql -u root'
alias mysqladmin='mysqladmin -u root'
alias urldecode='python3 -c "import sys, urllib.parse; print( urllib.parse.unquote_plus(sys.argv[1]) )"'

alias semacs='emacs -nw -Q'
alias pymacs='emacs -q -load ~/.pymacs.d/init.el'
bindkey -s "^x^f" $'semacs '

bindkey -s ",e" $'vim'

#from http://jaderholm.com/configs/zshrc
# Global Aliases
alias -g L='|less'
alias -g M='|more'
alias -g G='|grep'
alias -g T='|tail -f'
alias -g H='|head -n 20'
alias -g W='|wc -l'
alias -g S='|sort'

alias -g has='ps aux | grep -v grep | grep'

