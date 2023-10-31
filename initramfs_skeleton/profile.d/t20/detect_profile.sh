#!/bin/sh
#
#
#

function detect_profile() {
	strings /bootpart_backup.img > /bootpart_backup_strings.txt
	msg
	if grep -q "demo.bin" /bootpart_backup_strings.txt ; then # Stock Cam v2 & Cam Pan
		msg "Camera is currently on Cam Pan v2 or Cam Pan stock firmware"
		current_profile="stock"
	
	elif grep -q "factory_t20_0P3N1PC_kernel" /bootpart_backup_strings.txt ; then
		msg "Camera is currently on OpenIPC firmware"
		current_profile="openipc"
	else
		msg "Unable to detect current firmware"
		rm /bootpart_backup_strings.txt
		return 1
	fi

	rm /bootpart_backup_strings.txt
}

detect_profile || return 1
