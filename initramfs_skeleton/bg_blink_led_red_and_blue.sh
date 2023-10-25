#!/bin/sh

blink_led_red_and_blue() {
	local red_led_gpio="38"
	local blue_led_gpio="39"

	echo 0 > /sys/class/gpio/gpio$red_led_gpio/value
	sleep 1
	echo 1 > /sys/class/gpio/gpio$red_led_gpio/value
	sleep 1

	echo 0 > /sys/class/gpio/gpio$blue_led_gpio/value
	sleep 1
	echo 1 > /sys/class/gpio/gpio$blue_led_gpio/value
	sleep 1
}

while true; do
	blink_led_red_and_blue
done
