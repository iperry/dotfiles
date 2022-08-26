#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <up|down|mute>"
    exit 1
fi

case $1 in
  up)
    pactl set-sink-volume @DEFAULT_SINK@ +2%
    ;;
  down)
    pactl set-sink-volume @DEFAULT_SINK@ -2%
    ;;
  mute)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    ;;

  *)
    echo "Usage: $0 <up|down|mute>"
    exit
    ;;
esac

SINK_MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

if [ $SINK_MUTE = "yes" ]; then
    volnoti-show -m
else
    VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')
    volnoti-show $VOL
fi
