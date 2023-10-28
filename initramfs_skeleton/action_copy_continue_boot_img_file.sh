#!/bin/sh
#
# Description: Copy SD card boot image that will be booted on next boot
#

function copy_continue_boot_img_file() {
	[ ! -f /sdcard/$continue_boot_img_filename ] && { msg "/sdcard/$continue_boot_img_filename file is missing" ; return 1 ; }
	[[ "$switch_profile" == "yes" ]] && { msg "New SD card image will not be copied when switch_profile is enabled" ; return 1 ; }

	msg_nonewline "Copying /sdcard/$continue_boot_img_filename to /sdcard/$sdcard_boot_img_name... "
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "cp /sdcard/$continue_boot_img_filename /sdcard/$sdcard_boot_img_name"
		msg
	else
		cp /sdcard/$continue_boot_img_filename /sdcard/$sdcard_boot_img_name && msg "done" || { msg "failed" ; return 1 ; }
	fi
}

copy_continue_boot_img_file || return 1
