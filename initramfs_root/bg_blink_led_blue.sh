#!/bin/sh
#
# Description: Blink blue LED every second
#

blink_led_blue() {
	local chip_family=$(ipcinfo-mips32 --family)
	source /leds_gpio.d/$chip_family.sh
	while true; do
		echo 0 > /sys/class/gpio/gpio$blue_led_gpio/value
		sleep 1
		echo 1 > /sys/class/gpio/gpio$blue_led_gpio/value
		sleep 1
	done
}

blink_led_blue
