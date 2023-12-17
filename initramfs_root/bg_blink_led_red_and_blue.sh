#!/bin/sh
#
# Description: Blink the red and blue LEDs every second
#

function blink_led_red_and_blue() {
	source /leds_gpio.d/leds_gpio.sh
	
	while true; do
		echo 0 > /sys/class/gpio/gpio$red_led_pin/value
		sleep 1
		echo 1 > /sys/class/gpio/gpio$red_led_pin/value
		sleep 1

		echo 0 > /sys/class/gpio/gpio$blue_led_pin/value
		sleep 1
		echo 1 > /sys/class/gpio/gpio$blue_led_pin/value
		sleep 1
	done
}

blink_led_red_and_blue
