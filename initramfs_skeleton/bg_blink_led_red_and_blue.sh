#!/bin/sh
#
# Description: Blink red and blue LEDs every second
#

blink_led_red_and_blue_loop() {
	source /functions_blink_leds.sh
	while true; do
		blink_led_red
		blink_led_blue
	done
}

blink_led_red_and_blue_loop
