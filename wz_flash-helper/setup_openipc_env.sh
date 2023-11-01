#!/bin/sh
#
# Description: Write env variables from file to env partition
#


WIFI_SSID="Wi-Fi name"
WIFI_PASSWORD="Wi-Fi password"



## These variables are optional, you can set them later
# MAC address example: 11:22:33:44:55:66
MAC_ADDRESS=""
# Timezone example: America/Los_Angeles
TIMEZONE=""





	
	
	
function get_wifi_gpio_pin() {
# Description: Return GPIO pin for queried camera model
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

function get_wifi_device_id() {
# Description: Initialize wifi board by setting its gpio pin then get it device id
# Syntax: get_wifi_id <gpio_pin>
	local gpio_pin="$1"
	
	echo $gpio_pin > /sys/class/gpio/export 
	echo out > /sys/class/gpio/$gpio_pin/direction 
	echo 1 > /sys/class/gpio/$gpio_pin/value 
	echo INSERT > /sys/devices/platform/jzmmc_v1.2.1/present
	
	local wifi_device_id=$(cat /sys/bus/mmc/devices/mmc1\:0001/mmc1\:0001\:1/vendor)
	echo -n $wifi_device_id
}


function detect_wifi_driver() {
	case $model in
		"pan_v1")
			wifi_driver="rtl8189ftv-t20-wyze-pan-v1"
			;;
		"v2")
			wifi_driver="rtl8189ftv-t20-wyze-v2"
			;;
		"v3")
			local wifi_gpio_pin=$(get_wifi_gpio_pin $model)
			local wifi_device_id=$(get_wifi_device_id $wifi_gpio_pin)
			
			[[ "$wifi_device_id" == "0x024c" ]] && wifi_driver="rtl8189ftv-t31-wyze-v3"
			[[ "$wifi_device_id" == "0x007a" ]] && wifi_driver="atbm603x-t31-wyze-v3"
			;;
			
		"v3c")
			wifi_driver="atbm603x-t31-wyze-v3"
			;;
		"pan_v2")
			wifi_driver="atbm603x-t31-wyze-pan-v2"
			;;
	esac
}

function set_openipc_custom_env() {	
	fw_setenv -l /tmp -c /etc/fw_env.config wlandev $wifi_driver
	fw_setenv -l /tmp -c /etc/fw_env.config wlanssid $WIFI_SSID
	fw_setenv -l /tmp -c /etc/fw_env.config wlanpass $WIFI_PASSWORD
	
	[[ ! "$MAC_ADDRESS" == "" ]] && fw_setenv -l /tmp -c /etc/fw_env.config wlanaddr $MAC_ADDRESS
	[[ ! "$TIMEZONE" == "" ]] && fw_setenv -l /tmp -c /etc/fw_env.config timezone $TIMEZONE	
}

function main() {
	detect_wifi_driver
	set_openipc_custom_env
}

main
