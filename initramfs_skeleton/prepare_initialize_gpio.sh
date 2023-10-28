#!/bin/sh




init_initialize_gpio() {
	case "$chip_family" in
		"t20")
			if [ ! -d /sys/class/gpio/gpio38 ]; then # Export red LED pin
				echo 38 > /sys/class/gpio/export
				echo 1 > /sys/class/gpio/gpio38/value
				echo out > /sys/class/gpio/gpio38/direction
			fi
	
			if [ ! -d /sys/class/gpio/gpio39 ]; then # Export blue LED pin
				echo 39 > /sys/class/gpio/export
				echo out > /sys/class/gpio/gpio39/direction
				echo 1 > /sys/class/gpio/gpio39/value
			fi

			if [ ! -d /sys/class/gpio/gpio39 ]; then # Export SD card pin
				echo 39 > /sys/class/gpio/export
				echo out > /sys/class/gpio/gpio39/direction
				echo 1 > /sys/class/gpio/gpio39/value
			fi
			;;
	
		"t31")
			if [ ! -d /sys/class/gpio/gpio38 ]; then # Export red LED pin
				echo 38 > /sys/class/gpio/export
				echo 1 > /sys/class/gpio/gpio38/value
				echo out > /sys/class/gpio/gpio38/direction
			fi
	
			if [ ! -d /sys/class/gpio/gpio39 ]; then # Export blue LED pin
				echo 39 > /sys/class/gpio/export
				echo out > /sys/class/gpio/gpio39/direction
				echo 1 > /sys/class/gpio/gpio39/value
			fi
			;;
	esac
}

init_initialize_gpio || return 1
