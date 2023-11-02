#!/bin/sh
#
# Description: Write user Wi-Fi, MAC address and Timezone variables to OpenIPC env partition
#              Use this script to do initial setup when you switch from stock to OpenIPC on the first time
#



# ---------- Begin of user customization ----------

## Wi-Fi authentication info
## Allowed characters for Wi-Fi SSID and password:
## alphanumeric(a-z, A-Z, 0-9), underscore(_), period(.), dash(-), colon(:), space( )
wifi_ssid="Wi-Fi name"
wifi_password="Wi-Fi password"


## The below variables are optional, leave them empty if are not sure
## They can be set later using SSH after OpenIPC boots up

## mac_address format: 00:11:22:aa:bb:cc
mac_address=""

## timezone format: Zone/SubZone, example: America/Los_Angeles
## Full list of time zones can be found here: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
timezone=""

# ---------- End of user customization ----------











##### DO NOT MODIFY THE BELOW CODE #####	

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
		"v3c")
			echo -n "59" ;;
		"pan_v2")
			echo -n "58" ;;
	esac
}

function get_wifi_vendor_id() {
# Description: Initialize Wi-Fi module by setting its gpio pin then get it device id
# Syntax: get_wifi_id <gpio_pin>
	local gpio_pin="$1"
	
	echo $gpio_pin > /sys/class/gpio/export 
	echo out > /sys/class/gpio/$gpio_pin/direction 
	echo 1 > /sys/class/gpio/$gpio_pin/value 
	echo INSERT > /sys/devices/platform/jzmmc_v1.2.1/present
	
	local wifi_device_id=$(cat /sys/bus/mmc/devices/mmc1\:0001/mmc1\:0001\:1/vendor)
	echo -n $wifi_vendor_id
}


function detect_openipc_wifi_driver() {
	case $model in
		"pan_v1")
			wifi_driver="rtl8189ftv-t20-wyze-pan-v1"
			;;
		"v2")
			wifi_driver="rtl8189ftv-t20-wyze-v2"
			;;
		"v3")
			local wifi_gpio_pin=$(get_wifi_gpio_pin $model)
			local wifi_device_id=$(get_wifi_vendor_id $wifi_gpio_pin)
			
			[[ "$wifi_vendor_id" == "0x024c" ]] && wifi_driver="rtl8189ftv-t31-wyze-v3"
			[[ "$wifi_vendor_id" == "0x007a" ]] && wifi_driver="atbm603x-t31-wyze-v3"
			;;
			
		"v3c")
			wifi_driver="atbm603x-t31-wyze-v3"
			;;
		"pan_v2")
			wifi_driver="atbm603x-t31-wyze-pan-v2"
			;;
	esac
}

function set_openipc_user_env() {
	fw_setenv_args="-l /tmp -c /etc/fw_env.config"
	
	fw_setenv $fw_setenv_args wlandev $wifi_driver
	fw_setenv $fw_setenv_args wlanssid $wifi_ssid
	fw_setenv $fw_setenv_args wlanpass $wifi_password
	
	[[ ! "$MAC_ADDRESS" == "" ]] && fw_setenv $fw_setenv_args wlanaddr $mac_address
	[[ ! "$TIMEZONE" == "" ]] && fw_setenv $fw_setenv_args timezone $timezone	
}

function main() {
	detect_openipc_wifi_driver
	set_openipc_user_env
}

main
