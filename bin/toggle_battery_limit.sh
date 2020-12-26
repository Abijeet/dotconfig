#!/bin/bash
# Used for toggling the battery charging limit. Checks if the limit is
# set to 100, if it is, sets it to a certain value.
declare -i LIMIT
LIMIT=`cat /sys/class/power_supply/BAT0/charge_control_end_threshold`

if [ $LIMIT -eq 100 ]
then
    # 75 is the limit here.
    echo 75 > /sys/class/power_supply/BAT0/charge_control_end_threshold
    echo "Battery Limit enabled."
else
    echo 100 > /sys/class/power_supply/BAT0/charge_control_end_threshold
	echo "Battery Limit disabled."
fi