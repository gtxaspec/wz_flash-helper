#!/bin/sh

blink_led_red() {
	local red_led_gpio="38"
	while true; do
		echo 0 > /sys/class/gpio/gpio$red_led_gpio/value
		sleep 1
		echo 1 > /sys/class/gpio/gpio$red_led_gpio/value
		sleep 1
	done
}

blink_led_red
