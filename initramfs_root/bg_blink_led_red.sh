#!/bin/sh
#
# Description: Blink red LED every second
#

blink_led_red() {
	echo 0 > /sys/class/gpio/gpio$red_led_gpio/value
	sleep 1
	echo 1 > /sys/class/gpio/gpio$red_led_gpio/value
	sleep 1
}

blink_led_blue_loop() {
	while true; do
		blink_led_red
	done
}

blink_led_blue_loop
