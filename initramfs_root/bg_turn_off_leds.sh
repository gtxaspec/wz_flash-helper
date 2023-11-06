#!/bin/sh
#
# Description: When LED blinking scripts are killed, they might still leave the LEDs on, this script turns them all off
#

function turn_off_leds() {
	local chip_family=$(ipcinfo --family)
	source /leds_gpio.d/$chip_family.sh
	
	echo 1 > /sys/class/gpio/gpio$red_led_pin/value
	echo 1 > /sys/class/gpio/gpio$blue_led_pin/value
}

turn_off_leds
