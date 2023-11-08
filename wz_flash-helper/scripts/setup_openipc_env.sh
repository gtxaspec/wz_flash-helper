#!/bin/sh
#
# Description: Write user Wi-Fi, MAC address, and Timezone variables to the OpenIPC env partition
#              Use this script to do initial setup when you switch from stock to OpenIPC for the first time
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
## If not set, a random MAC address will be used by OpenIPC
mac_address=""

## Example: America/Los Angeles
## Full list of time zones with the correct format can be found here: https://github.com/openwrt/luci/blob/master/modules/luci-base/ucode/zoneinfo.uc
## If not set, Etc/GMT will be used by default by OpenIPC
timezone=""



## Only use this option to override for Wi-Fi module driver detection if the program cannot detect the correct camera driver
set_wifi_driver_manually="no"
wifi_driver=""

# ---------- End of user customization ----------










##### DO NOT MODIFY THE BELOW CODE #####	

function get_wifi_gpio_pin() {
# Description: Return GPIO pin for the queried camera model
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
# Description: Obtain and return the Wi-Fi module vendor ID after initializing its GPIO pin
# Syntax: get_wifi_id <gpio_pin>
	local wifi_gpio_pin="$1"
	
	if [ ! -d /sys/class/gpio/gpio$wifi_gpio_pin ]; then
		echo $wifi_gpio_pin > /sys/class/gpio/export
		echo out > /sys/class/gpio/gpio$wifi_gpio_pin/direction
		echo 1 > /sys/class/gpio/gpio$wifi_gpio_pin/value
	fi
	
	echo INSERT > /sys/devices/platform/jzmmc_v1.2.1/present
	sleep 1

	local wifi_vendor_id=$(cat /sys/bus/mmc/devices/mmc1:0001/mmc1:0001:1/vendor)
	echo -n $wifi_vendor_id
}

function detect_openipc_wifi_driver() {
# Description: Assign Wi-Fi driver for OpenIPC based on the camera model and vendor ID
	msg "- Detecting driver for Wi-Fi module"
	[[ "$set_wifi_driver_manually" == "yes" ]] && { msg " + Using custom Wi-Fi driver value: $wifi_driver" ; return 0 ; }
	
	case $model in
	
		"pan_v1")
			wifi_driver="rtl8189ftv-t20-wyze-pan-v1"
			;;
		"v2")
			wifi_driver="rtl8189ftv-t20-wyze-v2"
			;;
		"v3")
			local wifi_gpio_pin=$(get_wifi_gpio_pin $model)
			wifi_vendor_id=$(get_wifi_vendor_id $wifi_gpio_pin)
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
	
	if [[ ! "$wifi_driver" == "" ]]; then # Exit function if Wi-Fi driver has been set
		msg " + Found driver: $wifi_driver"
		return 0
	else
		msg " + Can not detect driver, please set it manually and run this script again"
		return 1
	fi
}

function set_openipc_user_env() {
# Description: Write user-specified variables to the env partition using fw_setenv
	msg
	msg "- Setting env variables"

	#---------- Wi-Fi SSID ----------
	msg_nonewline " + Setting Wi-Fi SSID... "
	fw_setenv wlanssid $wifi_ssid && msg "ok" || { msg "failed" ; return 1 ; }

	#---------- Wi-Fi password ----------
	msg_nonewline " + Setting Wi-Fi password... "
	fw_setenv wlanpass $wifi_password && msg "ok" || { msg "failed" ; return 1 ; }

	#---------- Wi-Fi driver ----------
	msg_nonewline " + Setting Wi-Fi driver... "
	if [[ ! "$wifi_driver" == "" ]]; then
		fw_setenv wlandev $wifi_driver && msg "ok" || { msg "failed" ; return 1 ; }
	else
		msg "not set because it is empty"
	fi

	#---------- MAC address ----------
	msg_nonewline " + Setting MAC address... "
	if [[ ! "$mac_address" == "" ]]; then
		fw_setenv wlanmac $mac_address && msg "ok" || { msg "failed" ; return 1 ; }
	else
		msg "not set because it is empty"
	fi
	
	#---------- Timezone ----------
	msg_nonewline " + Setting Timezone... "
	if [[ ! "$timezone" == "" ]]; then
		fw_setenv timezone $timezone && msg "ok" || { msg "failed" ; return 1 ; }
	else
		msg "not set because it is empty"
	fi
}

matched_profile="openipc"

custom_script_matched_profile_check $matched_profile || return 0
detect_openipc_wifi_driver || return 1
set_openipc_user_env || return 1
