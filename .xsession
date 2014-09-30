#!/bin/sh
feh --bg-scale /home/perry/Pictures/blumblaum_3929361972.jpg
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 6 --transparent true --alpha 0 --tint 0x000040 --height 18 &
nm-applet &
xcompmgr &
/usr/bin/xmonad
