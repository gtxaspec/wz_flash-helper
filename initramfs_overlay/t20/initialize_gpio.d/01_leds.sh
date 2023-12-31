#!/bin/sh
#
# Description: Initialize GPIO LEDs pins
#


if [ ! -d /sys/class/gpio/gpio38 ]; then # Export red LED pin
	echo 38 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio38/direction
	echo 1 > /sys/class/gpio/gpio38/value
fi

if [ ! -d /sys/class/gpio/gpio39 ]; then # Export blue LED pin
	echo 39 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio39/direction
	echo 1 > /sys/class/gpio/gpio39/value
fi

echo 43 > /sys/class/gpio/export
echo in > /sys/class/gpio/gpio43/direction
sleep 3
