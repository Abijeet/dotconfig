#!/bin/sh

#############################################
# This is a simple battery warning script.  #
# It uses i3's nagbar to display warnings.  #
#                                           #
# @author agribu                            #
#############################################
# Source: https://github.com/stagnation/i3-battery-warning/blob/master/i3batwarn.sh
#############################################

# Configureed via crontab
# */2 * * * * /home/abijeet/bin/i3_battery_warn.sh > /tmp/batterywarn.log

# lock file location
export LOCK_FILE='/tmp/battery_state.lock'

# check if another copy is running
if [ -e "${LOCK_FILE}" ] ; then

	pid="$(awk '{print $1}' "${LOCK_FILE}")"
	ppid="$(awk '{print $2}' "${LOCK_FILE}")"
	# validate contents of previous lock file
	vpid="${pid:-"0"}"
	vppid="${ppid:-"0"}"

	if [ "${vpid}" -lt '2' ] || [ "${vppid}" -lt '2' ] ; then
		# corrupt lock file $LOCK_FILE ... Exiting
		cp -f "${LOCK_FILE}" "${LOCK_FILE}.$(date +%Y%m%d%H%M%S)"
		exit
	fi

	# check if ppid matches pid
	if ps -f -p "${pid}" --no-headers | grep -q "${ppid}" ; then
		# another copy of script running with process id ${pid}
		exit
	else
		# bogus lock file found, removing
		rm -f "${LOCK_FILE}" >/dev/null
	fi

fi

pid="$$"
ps -f -p "${pid}" --no-headers | awk '{print $2,$3}' > "${LOCK_FILE}"
# starting with process id $pid

# set Battery
BATTERY="$(echo '/sys/class/power_supply/BAT'?)"

# get battery status
STAT="$(cat "${BATTERY}/status")"

# get remaining energy value
REM="$(grep -E "POWER_SUPPLY_(CHARGE|ENERGY)_NOW" "${BATTERY}/uevent" | cut -d '=' -f2)"

# get full energy value
FULL="$(grep -E "POWER_SUPPLY_(CHARGE|ENERGY)_FULL_DESIGN" "${BATTERY}/uevent" | cut -d '=' -f2)"

# get current energy value in percent
PERCENT="$((REM * 100 / FULL))"

# set error message
MESSAGE="Low battery warning, find charger"

# set energy limit in percent, where warning should be displayed
LIMIT="15"

I3BAT_TMPDIR="$(mktemp --directory --tmpdir i3batwarn.XXX)"
NAGBARPIDFILE="${I3BAT_TMPDIR}/nagbarpid_file"

# show warning if energy limit in percent is less then user set limit and
# if battery is discharging
if [ "${PERCENT}" -le "${LIMIT}" ] && [ "${STAT}" = "Discharging" ] ; then
  #chek if nagbarfile is empty: else open new - to avoid multiples
	if [ ! -s "${NAGBARPIDFILE}" ] ; then
		/usr/bin/i3-nagbar -m "${MESSAGE}" &
		echo "$!" > "${NAGBARPIDFILE}"
	elif ps -e | grep "$(cat "${NAGBARPIDFILE}")" | grep "i3-nagbar" ; then
		echo "pidfile in order, nothing to do"
	else
		rm "${NAGBARPIDFILE}"
		/usr/bin/i3-nagbar -m "${MESSAGE}" &
		echo "$!" > "${NAGBARPIDFILE}"
	fi #else if, nagbarpid points to something else create new.
fi

#warning, if the nagbar is closed manually the pidfile might not be emptied properly
#for safety the charging requirement below is relaxed, if you use the nagbar for other reasons
#it might get closed accidentaly by this
if [ "${PERCENT}" -gt "${LIMIT}" ] || [ "${STAT}" = "Charging" ] ; then
	if [ -s "${NAGBARPIDFILE}" ] ; then
		if ps -e | grep "$(cat "${NAGBARPIDFILE}")" | grep "i3-nagbar" ; then
			kill "$(cat "${NAGBARPIDFILE}")"
			rm "${NAGBARPIDFILE}"
		else
			rm "${NAGBARPIDFILE}"
		fi
	fi
fi
