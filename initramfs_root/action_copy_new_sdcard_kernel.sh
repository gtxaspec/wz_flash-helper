#!/bin/sh
#
# Description: Make a copy of user-specified SD card kernel and rename it to let it be booted by uboot on next boot
#

function copy_new_sdcard_kernel() {
	[ ! -f /sdcard/$new_sdcard_kernel ] && { msg "/sdcard/$new_sdcard_kernel file is missing" ; return 1 ; }
	[[ "$switch_profile" == "yes" ]] && { msg "New SD card kernel will not be copied when switch_profile is enabled" ; return 1 ; }

	msg
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "cp /sdcard/$new_sdcard_kernel /sdcard/$current_profile_sdcard_kernel_name"
	else
		msg_nonewline "Copying /sdcard/$new_sdcard_kernel to /sdcard/$current_profile_sdcard_kernel_name... "
		cp /sdcard/$new_sdcard_kernel /sdcard/$current_profile_sdcard_kernel_name && msg "done" || { msg "failed" ; return 1 ; }
	fi
}

copy_new_sdcard_kernel || return 1
