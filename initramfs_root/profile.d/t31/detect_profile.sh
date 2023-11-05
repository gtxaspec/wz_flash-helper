#!/bin/sh
#
# Description: Detect current profile by analyzing uboot strings
#

function detect_profile() {
# Description: Detect current profile
	msg
	if grep -q "demo_wcv3.bin" /bootpart_backup.img.strings ; then # Stock Cam v3
		msg "Camera is currently on Cam v3 stock firmware"
		current_profile="stock"
	
	elif grep -q "recovery_wcpv2.bin" /bootpart_backup.img.strings ; then # Stock Cam Pan v2
		msg "Camera is currently on Cam Pan v2 stock firmware"
		current_profile="stock"
	
	elif grep -q "factory_t31_0P3N1PC_kernel" /bootpart_backup.img.strings ; then
		msg "Camera is currently on OpenIPC firmware"
		current_profile="openipc"
	else
		msg "Unable to detect current firmware"
		return 1
	fi
}

detect_profile || return 1
