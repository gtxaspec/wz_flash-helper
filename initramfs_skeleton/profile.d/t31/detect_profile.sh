#!/bin/sh
#
#
#

function detect_profile() {
	strings /boot_backup.img > /boot_backup_strings.txt
	
	if grep -q "demo_wcv3.bin" /boot_backup_strings.txt ; then # Stock Cam v3
		msg "Camera is currently on Cam v3 stock firmware"
		current_profile="stock"
	
	elif grep -q "recovery_wcpv2.bin" /boot_backup_strings.txt ; then # Stock Cam Pan v2
		msg "Camera is currently on Cam Pan v2 stock firmware"
		current_profile="stock"
	
	elif grep -q "factory_0P3N1PC_kernel" /boot_backup_strings.txt ; then
		msg "Camera is currently on OpenIPC firmware"
		current_profile="openipc"
	else
		{ msg "Unable to detect current firmware" ; return 1 ; }
	fi
	
	rm /boot_backup_strings.txt
}

detect_profile.sh || return 1
