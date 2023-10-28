#!/bin/sh
#
# Description: Blink red LED every second
#

blink_led_blue_loop() {
	source /functions_blink_leds.sh
	while true; do
		blink_led_red
	done
}

blink_led_blue_loop
