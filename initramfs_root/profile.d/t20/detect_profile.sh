#!/bin/sh
#
# Description: Detect the current profile by analyzing uboot strings
#

function detect_profile() {
	msg
	if grep -q "demo.bin" /boot_backup.img.strings ; then # Stock Cam v2 & Cam Pan
		msg "Camera is currently on Cam Pan v2 or Cam Pan stock firmware"
		current_profile="stock"
	
	elif grep -q "factory_t20_0P3N1PC_kernel" /boot_backup.img.strings ; then
		msg "Camera is currently on OpenIPC firmware"
		current_profile="openipc"
	else
		msg_color red "Unable to detect current firmware"
		return 1
	fi
}

detect_profile || return 1
