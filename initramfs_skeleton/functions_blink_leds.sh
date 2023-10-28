#!/bin/sh
#
#
#

blink_led_blue() {
	case "${chip_family}" in
		"t20")
			local blue_led_gpio="39"
			echo 0 > /sys/class/gpio/gpio$blue_led_gpio/value
			sleep 1
			echo 1 > /sys/class/gpio/gpio$blue_led_gpio/value
			sleep 1
			;;
		"t31")
			local blue_led_gpio="39"
			echo 0 > /sys/class/gpio/gpio$blue_led_gpio/value
			sleep 1
			echo 1 > /sys/class/gpio/gpio$blue_led_gpio/value
			sleep 1
			;;
	esac	
}

blink_led_red() {
	case "${chip_family}" in
		"t20")
			local red_led_gpio="39"
			echo 0 > /sys/class/gpio/gpio$red_led_gpio/value
			sleep 1
			echo 1 > /sys/class/gpio/gpio$red_led_gpio/value
			sleep 1
			;;
		"t31")
			local red_led_gpio="39"
			echo 0 > /sys/class/gpio/gpio$red_led_gpio/value
			sleep 1
			echo 1 > /sys/class/gpio/gpio$red_led_gpio/value
			sleep 1
			;;
	esac	
}
