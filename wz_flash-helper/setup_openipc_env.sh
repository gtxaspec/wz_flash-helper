#!/bin/sh
#
# Description: Write env variables from file to env partition
#

function get_wifi_gpio_pin() {
# Description: Return GPIO pin for a model
# Syntax: get_wifi_gpio_pin <model>
	local model="$1"
	case $model in
		"pan_v1")
			echo -n "62" ;;
		"v2")
			echo -n "62" ;;
		"v3")
			echo -n "59" ;;
		"pan_v2")
			echo -n "58" ;;
	esac
}

function initialize_gpio_wifi() {
# Description: Initialize wifi by setting gpio pin
# Syntax: get_wifi_gpio_pin <gpio_pin>
	local gpio_pin="$1"
	
	echo $gpio_pin > /sys/class/gpio/export 
	echo out > /sys/class/gpio/$gpio_pin/direction 
	echo 1 > /sys/class/gpio/$gpio_pin/value 
	
	echo INSERT > /sys/devices/platform/jzmmc_v1.2.1/present
	cat /sys/bus/mmc/devices/mmc1\:0001/mmc1\:0001\:1/vendor
}


function main() {
	openipc_env_file="/sdcard/wz_flash-helper/openipc_env.txt"
	
	case $chip_family in
		"t20")
			config_partname="stock_para"

		"t31")
			config_partname="stock_cfg"
}

main
for 
	fw_setenv -l /tmp -c /sdcard/fw_env.config
