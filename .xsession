#trayer --edge top --align right --SetDockType true --height 18 --widthtype pixels --width 100 --expand true &
xmodmap ~/.Xmodmap &
#feh --bg-scale /home/perry/mandolux-collateral-l-1680.jpg
#feh --bg-center /home/perry/Photos/8g/1440.jpg
trayer --edge top --align right --widthtype request --transparent true --alpha 255 &
feh --bg-center /home/perry/vladstudio0.jpg &
xsetroot -cursor_name left_ptr
xmonad | dzen2 -ta l
xbindkeys &
gnome-screensaver &
