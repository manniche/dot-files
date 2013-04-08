#!/usr/bin/env bash
#sleep 100

#/usr/bin/ssh-agent /usr/bin/dbus-launch --exit-with-session &
#/usr/bin/dbus-launch --exit-with-session &
/usr/bin/wmname LG3D &
/usr/bin/nm-applet &
#wicd-client &
/usr/bin/owncloud &
#xfce4-power-manager --restart &

exec /usr/bin/awesome -c /home/stm/.config/awesome/rc.lua
