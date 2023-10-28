#!/bin/sh
#
# Description: Blink blue LED every second
#

blink_led_blue() {
	echo 0 > /sys/class/gpio/gpio$blue_led_gpio/value
	sleep 1
	echo 1 > /sys/class/gpio/gpio$blue_led_gpio/value
	sleep 1
}

blink_led_blue_loop() {
	source /functions_blink_leds.sh
	while true; do
		blink_led_blue
	done
}

blink_led_blue_loop
