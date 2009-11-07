#!/bin/sh

emacs --daemon &
conkeror --daemon &

ssh-agent awesome & wmpid=$!

xmodmap ~/.xmodmap &
xrdb -load ~/.Xdefaults &
xset r rate 230 40 &

#~/local/bin/ssh-add.sh &
wmname LG3D

wait $wmpid
