#!/bin/sh


red_led_gpio="38"
blue_led_gpio="39"

blink_red_led() {
	echo 0 > /sys/class/gpio/gpio$red_led_gpio/value
	sleep 1
	echo 1 > /sys/class/gpio/gpio$red_led_gpio/value
	sleep 1
}

blink_blue_led() {
	echo 0 > /sys/class/gpio/gpio$blue_led_gpio/value
	sleep 1
	echo 1 > /sys/class/gpio/gpio$blue_led_gpio/value
	sleep 1
}

while true; do
	blink_red_led
	blink_blue_led
done

