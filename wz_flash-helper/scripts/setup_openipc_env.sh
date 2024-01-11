#!/bin/sh
#
# Description: Write user Wi-Fi SSID, password, MAC address, and Timezone variables to the OpenIPC env partition
#              Use this script to do initial setup when you switch from stock to OpenIPC for the first time
#              This script is only run if the running firmware is openipc



# ---------- Begin of user customization ----------

## Wi-Fi authentication info
## All printable characters are allowed for Wi-Fi name and password (a-z, A-Z, 0-9, all special characters)
read -r -d '' wifi_ssid <<'EOF'
replace_this_line_with_your_wifi_ssid
EOF

read -r -d '' wifi_password <<'EOF'
replace_this_line_with_your_wifi_password
EOF



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
manual_wifi_driver=""

# ---------- End of user customization ----------










##### DO NOT MODIFY THE BELOW CODE #####

function get_wifi_vendor_id() {
# Description: Obtain and return the Wi-Fi module vendor ID
	echo INSERT > /sys/devices/platform/jzmmc_v1.2.1/present
	sleep 1

	local vendor_file="/sys/bus/mmc/devices/mmc?:????/mmc?:????:?/vendor" # Use wildcard because Wi-Fi vendor ID file path might randomly change
	local wifi_vendor_id=$(cat $vendor_file)
	echo -n $wifi_vendor_id
}

function detect_openipc_wifi_driver() {
# Description: Assign Wi-Fi driver for OpenIPC based on camera model and vendor ID
	msg "Detecting driver for Wi-Fi module"

	if [[ "$set_wifi_driver_manually" == "yes" ]]; then
		msg_nonewline "   Using custom Wi-Fi driver value: " && msg_color cyan "$manual_wifi_driver"
		wifi_driver=$manual_wifi_driver
		return 0
	fi

	case $model in
		"pan_v1")
			wifi_driver="rtl8189ftv-t20-wyze-pan-v1"
			;;
		"v2")
			wifi_driver="rtl8189ftv-t20-wyze-v2"
			;;
		"v3")
			local wifi_vendor_id=$(get_wifi_vendor_id)
			[[ "$wifi_vendor_id" == "0x024c" ]] && wifi_driver="rtl8189ftv-t31-wyze-v3"
			[[ "$wifi_vendor_id" == "0x007a" ]] && wifi_driver="atbm603x-t31-wyze-v3"
			;;
		"v3c")
			wifi_driver="atbm603x-t31-wyze-v3"
			;;
		"pan_v2")
			wifi_driver="atbm603x-t31-wyze-pan-v2"
			;;
		*)
			msg_color red "    Your camera model is not supported by this script"
			;;
	esac

	if [ -z "$wifi_driver" ]; then # Exit function if Wi-Fi driver has been set
		msg_color red "    Can not detect driver, please set it manually and run this script again"
		return 1
	else
		msg_nonewline "   Found driver: " && msg_color cyan "$wifi_driver"
	fi
}

function set_openipc_user_env() {
# Description: Write user-specified variables to the env partition using fw_setenv
	msg
	msg "Setting env variables"

	#---------- Wi-Fi SSID ----------
	msg_nonewline "   Setting Wi-Fi SSID... "
	if [ -z "$wifi_ssid" ]; then
		msg_color_nonewline lightbrown "not set "
		msg "because it is empty"

	elif [ "$wifi_ssid" == "$(fw_printenv wlanssid | sed 's/wlanssid=//')" ]; then
		msg_color_nonewline lightbrown "skipping "
		msg "because it is the same as the old value"

	else
		fw_setenv wlanssid $(echo $wifi_ssid) && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
	fi

	#---------- Wi-Fi password ----------
	msg_nonewline "   Setting Wi-Fi password... "
	if [ -z "$wifi_password" ]; then
		msg_color_nonewline lightbrown "not set "
		msg "because it is empty"

	elif [ "$wifi_password" == "$(fw_printenv wlanpass | sed 's/wlanpass=//')" ]; then
		msg_color_nonewline lightbrown "skipping "
		msg "because it is the same as the old value"

	else
		fw_setenv wlanpass $(echo $wifi_password) && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
	fi

	#---------- Wi-Fi driver ----------
	msg_nonewline "   Setting Wi-Fi driver... "
	if [ -z "$wifi_driver"]]; then
		msg_color_nonewline lightbrown "not set "
		msg "because it is empty"

	elif [[ "$wifi_driver" == "$(fw_printenv wlandev | sed 's/wlandev=//')" ]]; then
		msg_color_nonewline lightbrown "skipping "
		msg "because it is the same as the old value"

	else
		fw_setenv wlandev $wifi_driver && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
	fi

	#---------- MAC address ----------
	msg_nonewline "   Setting MAC address... "
	if [ -z "$mac_address" ]; then
		msg_color_nonewline lightbrown "not set "
		msg "because it is empty"

	elif [[ "$mac_address" == "$(fw_printenv wlanmac | sed 's/wlanmac=//')" ]]; then
		msg_color_nonewline lightbrown "skipping "
		msg "because it is the same as the old value"

	else
		fw_setenv wlanmac $mac_address && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
	fi

	#---------- Timezone ----------
	msg_nonewline "   Setting Timezone... "
	if [ -z "$timezone" ]; then
		msg_color_nonewline lightbrown "not set "
		msg "because it is empty"

	elif [[ "$timezone" == "$(fw_printenv timezone | sed 's/timezone=//')" ]]; then
		msg_color_nonewline lightbrown "skipping "
		msg "because it is the same as the old value"

	else
		fw_setenv timezone $timezone && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
	fi

	#---------- Device model ----------
	msg_nonewline "   Setting Device model... "
	if [ -z "$model" ]; then
		msg_color_nonewline lightbrown "not set "
		msg "because it is empty"

	elif [[ "$model" == "$(fw_printenv devicemodel | sed 's/devicemodel=//')" ]]; then
		msg_color_nonewline lightbrown "skipping "
		msg "because it is the same as the old value"

	else
		fw_setenv devicemodel $model && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
	fi
}

matched_firmware="openipc"

custom_script_current_firmware_check $matched_firmware || return 0
detect_openipc_wifi_driver || return 1
set_openipc_user_env || return 1
