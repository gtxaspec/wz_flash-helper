#!/bin/sh
#
# Description: Blink red and blue LEDs every second
#

blink_led_red_and_blue() {
	echo 0 > /sys/class/gpio/gpio$red_led_gpio/value
	sleep 1
	echo 1 > /sys/class/gpio/gpio$red_led_gpio/value
	sleep 1

	echo 0 > /sys/class/gpio/gpio$blue_led_gpio/value
	sleep 1
	echo 1 > /sys/class/gpio/gpio$blue_led_gpio/value
	sleep 1
}

blink_led_red_and_blue_loop() {
	while true; do
		blink_led_red_and_blue
	done
}

blink_led_red_and_blue_loop
