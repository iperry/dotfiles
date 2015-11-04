#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <up|down|mute>"
    exit 1
fi

pulseaudio-ctl $1

PULSEAUDIO_STATUS="$(pulseaudio-ctl full-status)"
VOL="$(echo $PULSEAUDIO_STATUS | awk '{print $1}')"
SINK_MUTE="$(echo $PULSEAUDIO_STATUS | awk '{print $2}')"
SOURCE_MUTE="$(echo $PULSEAUDIO_STATUS | awk '{print $3}')"

if [ $SINK_MUTE = "yes" ]; then
    volnoti-show -m
else
    volnoti-show $VOL
fi
