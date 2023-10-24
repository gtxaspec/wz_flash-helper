#!/bin/sh

function initialize_t20_gpio_sdcard() {
# Description: T20 cameras need this to get SD card detected
	echo 43 > /sys/class/gpio/export
	echo in > /sys/class/gpio/gpio43/direction
	sleep 3 # Required delay interval for SD card init on T20
}

function initialize_gpio_leds() {
# Description: Export LEDs GPIO pins if they don't exist to enable LEDs
	if [ ! -d /sys/class/gpio/gpio38 ]; then
		echo 38 > /sys/class/gpio/export
		echo out > /sys/class/gpio/gpio38/direction
		echo 1 > /sys/class/gpio/gpio38/value
	fi
	
	if [ ! -d /sys/class/gpio/gpio39 ]; then
		echo 39 > /sys/class/gpio/export
		echo out > /sys/class/gpio/gpio39/direction
		echo 1 > /sys/class/gpio/gpio39/value
	fi
}

