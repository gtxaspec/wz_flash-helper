#!/bin/sh
#
# Description: Detect camera model by reading the uboot wlandev variable
#

function detect_model() {
	openipc_wifi_driver=$(fw_printenv wlandev | sed 's/wlandev//')

	case $openipc_wifi_driver in
		"tl8189ftv-t20-wyze-pan-v1")
			model="pan_v1"
			;;
			
		"tl8189ftv-t20-wyze-v2")
			model="v2"
			;;
		*)
			model="unknown"
			msg "Unable to detect camera model by reading the uboot wlandev variable"
			;;
	esac
}

detect_model || return 1
