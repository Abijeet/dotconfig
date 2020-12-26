#!/bin/bash
# Determine if touch pad is enabled or disabled
declare -i ID
ID=`xinput list | grep -Eo 'Touchpad\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}'`
echo `xinput list-props $ID|grep 'Device Enabled'|awk '{print $4}'|grep 1`