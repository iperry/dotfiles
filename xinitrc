[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 5 --transparent true --alpha 0 --tint 0x202020 --height 20 &
picom -f -D 10 -r 5 &
feh --bg-scale pics/15251.jpg --bg-scale pics/15251.jpg
volnoti &
xscreensaver -no-splash &
exec xmonad
