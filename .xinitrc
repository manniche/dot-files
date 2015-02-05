#!/usr/bin/env bash

/usr/bin/ssh-agent /usr/bin/dbus-launch --exit-with-session &
#/usr/bin/dbus-launch --exit-with-session &
/usr/bin/wmname LG3D &
/usr/bin/owncloud &
/usr/bin/SpiderOak &
xmodmap ~/.Xmodmap
exec i3
