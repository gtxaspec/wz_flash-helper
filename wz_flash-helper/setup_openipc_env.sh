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



## The two below variables are optional, leave them empty if you are not sure
## They can be set later using SSH after OpenIPC boots up

## mac_address format: 00:11:22:aa:bb:cc
## If not set, OpenIPC uses a random MAC address for networking
mac_address=""

## Example: America/Los_Angeles, EST
## Full list of time zones can be found here: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
## If not set, OpenIPC uses UTC
timezone=""



## Only use this option if the program can not detect driver for Wi-Fi module
wifi_driver_manual=""



# ---------- End of user customization ----------











##### DO NOT MODIFY THE BELOW CODE #####	

function get_wifi_vendor_id() {
# Description: Obtain and return Wi-Fi module vendor ID after initializing its GPIO pin
# Syntax: get_wifi_id <gpio_pin>
	echo INSERT > /sys/devices/platform/jzmmc_v1.2.1/present
	
	local wifi_vendor_id=$(cat /sys/bus/mmc/devices/mmc1\:0001/mmc1\:0001\:1/vendor)
	echo -n $wifi_vendor_id
}


function detect_openipc_wifi_driver() {
# Description: Assign Wi-Fi driver for OpenIPC based on camera model and vendor ID
	case $model in
	
		"pan_v1")
			wifi_driver="rtl8189ftv-t20-wyze-pan-v1"
			;;
		"v2")
			wifi_driver="rtl8189ftv-t20-wyze-v2"
			;;
		"v3")
			wifi_driver=$(get_wifi_vendor_id)
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
# Description: Write user-specified variables to env partition using fw_setenv
	fw_setenv_args="-l /tmp -c /etc/fw_env.config"
	
	fw_setenv $fw_setenv_args wlanssid $wifi_ssid
	fw_setenv $fw_setenv_args wlanpass $wifi_password
	
	if [[ ! "$wifi_driver" == "" ]]; then
		fw_setenv $fw_setenv_args wlandev $wifi_driver
	else
		msg "Can not detect driver for Wi-Fi module, using manually set value: $wifi_driver_manual"
		fw_setenv $fw_setenv_args wlandev $wifi_driver_manual
	fi
	
	[[ ! "$mac_address" == "" ]] && fw_setenv $fw_setenv_args wlanaddr $mac_address
	[[ ! "$timezone" == "" ]] && fw_setenv $fw_setenv_args timezone $timezone
}

function main() {
	detect_openipc_wifi_driver
	set_openipc_user_env
}

main
