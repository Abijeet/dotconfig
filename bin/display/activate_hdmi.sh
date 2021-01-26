#!/bin/sh
# Activate HDMI
xrandr --output eDP1 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off

## Sometimes workspace 4 refuses to go to HDMI1 when enabled, fix that
i3-msg "workspace 4. ; move workspace to HDMI1"
