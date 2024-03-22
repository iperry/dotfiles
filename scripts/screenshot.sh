#!/bin/sh
focusedwindow=$(xdotool getactivewindow)
flameshot gui -g >/dev/null
if [ "$focusedwindow" == "$(xdotool getactivewindow)" ]
then
	xdotool windowactivate $focusedwindow
fi
