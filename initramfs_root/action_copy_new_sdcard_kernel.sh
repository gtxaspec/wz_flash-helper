#!/bin/sh
#
# Description: Make a copy of user custom kernel with name that will be booted by uboot on next boot
#

function copy_new_sdcard_kernel() {
	[ ! -f /sdcard/$new_sdcard_kernel_name ] && { msg "/sdcard/$new_sdcard_kernel_name file is missing" ; return 1 ; }
	[[ "$switch_profile" == "yes" ]] && { msg "New SD card kernel will not be copied when switch_profile is enabled" ; return 1 ; }

	msg
	msg "---------- Begin of copy SD card kernel ----------"
	msg_nonewline "Copying /sdcard/$current_profile_sdcard_kernel_name to /sdcard/$new_sdcard_kernel_name... "
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "cp /sdcard/$current_profile_sdcard_kernel_name /sdcard/$new_sdcard_kernel_name"
		msg
	else
		cp /sdcard/$current_profile_sdcard_kernel_name /sdcard/$new_sdcard_kernel && msg "done" || { msg "failed" ; return 1 ; }
	fi
	msg "----------- End of copy SD card kernel -----------"
	msg
}

copy_new_sdcard_kernel || return 1
