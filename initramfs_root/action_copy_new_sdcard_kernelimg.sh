#!/bin/sh
#
# Description: Copy new SD card boot image that will be booted on next boot
#

function copy_new_sdcard_kernelimg() {
	[ ! -f /sdcard/$new_sdcard_kernelimg_name ] && { msg "/sdcard/$new_sdcard_kernelimg_name file is missing" ; return 1 ; }
	[[ "$switch_profile" == "yes" ]] && { msg "New SD card boot image will not be copied when switch_profile is enabled" ; return 1 ; }

	msg
	msg "---------- Begin of copy SD card kernel image ----------"
	msg_nonewline "Copying /sdcard/$current_profile_sdcard_kernelimg_name to /sdcard/$new_sdcard_kernelimg_name... "
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "cp /sdcard/$current_profile_sdcard_kernelimg_name /sdcard/$new_sdcard_kernelimg_name"
		msg
	else
		cp /sdcard/$current_profile_sdcard_kernelimg_name /sdcard/$new_sdcard_kernelimg && msg "done" || { msg "failed" ; return 1 ; }
	fi
	msg "----------- End of copy SD card kernel image -----------"
	msg
}

copy_new_sdcard_kernelimg || return 1
