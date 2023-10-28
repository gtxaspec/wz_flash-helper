#!/bin/sh
#
#
#

function detect_profile() {
	strings /boot_backup.img > /boot_backup_strings.txt
	
	if grep -q "demo.bin" /boot_backup_strings.txt ; then # Stock Cam v2 & Cam Pan
		msg "Camera is currently on Cam Pan v2 or Cam Pan stock firmware"
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
