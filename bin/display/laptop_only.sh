#!/bin/sh
# Activate Laptop display only
xrandr --output eDP1 --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI1 --off --output VIRTUAL1 --off
