#!/bin/bash

battery_details=$(pmset -g batt)

# Exit if no battery exists.
if ! echo "$battery_details" | grep -q InternalBattery; then
	exit 1
fi

charged=$(echo "$battery_details" | grep -w 'charged')
charging=$(echo "$battery_details" | grep -w 'AC Power')
discharging=$(echo "$battery_details" | grep -w 'Battery Power')
time=$(echo "$battery_details" | grep -Eo '([0-9][0-9]|[0-9]):[0-5][0-9]')
percent=$(echo "$battery_details" | grep -o "[0-9]*"%)

CHARGE="" && [[ "$charging" != "" ]] && CHARGE="⌁"

if [ "$percent" != "100%" ];
then
	echo "|$CHARGE$percent$CHARGE| "
fi
