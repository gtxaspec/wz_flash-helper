#!/bin/sh
#
#
#

case "$chip_family" in
	"t20")
		blue_led_gpio="38"
		red_led_gpio="39"
		;;
	"t31")
		blue_led_gpio="38"
		red_led_gpio="39"
		;;
esac

blink_led_blue() {
	echo 0 > /sys/class/gpio/gpio$blue_led_gpio/value
	sleep 1
	echo 1 > /sys/class/gpio/gpio$blue_led_gpio/value
	sleep 1
}

blink_led_red() {
	echo 0 > /sys/class/gpio/gpio$red_led_gpio/value
	sleep 1
	echo 1 > /sys/class/gpio/gpio$red_led_gpio/value
	sleep 1
}

