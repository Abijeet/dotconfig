#!/bin/sh
# Check and enable HDMI output if connected
extern=HDMI1

if xrandr | grep "$extern connected"; then
	xrandr --output eDP1 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rate 60.00 --rotate normal --output VIRTUAL1 --off
fi
