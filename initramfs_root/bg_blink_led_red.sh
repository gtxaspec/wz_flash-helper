#!/bin/sh
#
# Description: Blink red LED every second
#

function blink_led_blue() {
	local chip_family=$(ipcinfo --family)
	source /leds_gpio.d/$chip_family.sh
	
	while true; do
		echo 0 > /sys/class/gpio/gpio$red_led_gpio/value
		sleep 1
		echo 1 > /sys/class/gpio/gpio$red_led_gpio/value
		sleep 1
	done
}

blink_led_blue
