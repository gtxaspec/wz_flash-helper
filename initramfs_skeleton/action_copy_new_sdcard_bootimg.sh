#!/bin/sh
#
# Description: Copy new SD card boot image that will be booted on next boot
#

function copy_new_sdcard_bootimg() {
	[ ! -f /sdcard/$new_sdcard_bootimg_name ] && { msg "/sdcard/$new_sdcard_bootimg_name file is missing" ; return 1 ; }
	[[ "$switch_profile" == "yes" ]] && { msg "New SD card boot image will not be copied when switch_profile is enabled" ; return 1 ; }

	msg_nonewline "Copying /sdcard/$current_profile_sdcard_bootimg_name to /sdcard/$new_sdcard_bootimg_name... "
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "cp /sdcard/$current_profile_sdcard_bootimg_name /sdcard/$new_sdcard_bootimg_name"
		msg
	else
		cp /sdcard/$current_profile_sdcard_bootimg_name /sdcard/$new_sdcard_bootimg && msg "done" || { msg "failed" ; return 1 ; }
	fi
}

copy_new_sdcard_bootimg || return 1
