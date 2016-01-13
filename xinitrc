# https://bugs.archlinux.org/task/46374
. /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 5 --transparent true --alpha 0 --tint 0x202020 --height 20 &
dropbox start &
compton --backend glx --vsync opengl -f -D 5 -r 5 &
feh --bg-scale pics/oslo_subway-wallpaper-3840x2160.jpg --bg-scale pics/phu_quoc_island_sunrise-wallpaper-3840x2160.jpg
volnoti &
xscreensaver -no-splash &
exec xmonad
