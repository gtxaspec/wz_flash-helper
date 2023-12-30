#!/bin/sh
#
# Description: When LED blinking scripts are killed, they might still leave the LEDs on, this script turns them all off
#

source /leds_gpio.d/leds_gpio.sh

echo 1 > /sys/class/gpio/gpio$red_led_pin/value
echo 1 > /sys/class/gpio/gpio$blue_led_pin/value

pkill -f bg_blink_led_blue.sh
pkill -f bg_blink_led_red.sh
pkill -f bg_blink_led_red_and_blue.sh
