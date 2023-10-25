#!/bin/sh

blink_led_blue() {
	local blue_led_gpio="39"
	while true; do
		echo 0 > /sys/class/gpio/gpio$blue_led_gpio/value
		sleep 1
		echo 1 > /sys/class/gpio/gpio$blue_led_gpio/value
		sleep 1
	done
}

blink_led_blue
