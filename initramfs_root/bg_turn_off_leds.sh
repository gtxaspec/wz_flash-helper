#!/bin/sh
#
# Description: When LED blinking scripts are killed, they might still leave the LEDs on, this script turns them all off
#

source /leds_gpio.d/leds_gpio.sh

echo 1 > /sys/class/gpio/gpio$red_led_pin/value
echo 1 > /sys/class/gpio/gpio$blue_led_pin/value
