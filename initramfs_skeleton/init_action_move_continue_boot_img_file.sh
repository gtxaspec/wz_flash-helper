#!/bin/sh
# Description: Rename SD card boot image that will be booted next boot


if [ ! -f /sdcard/$continue_boot_img_filename ]; then
	if [[ ! "$switch_fw" == "yes" ]]; then
		msg "Renaming /sdcard/$continue_boot_img_filename to /sdcard/$sdcard_boot_img_name"
		if [[ "$dry_run" == "yes" ]]; then	
			msg_dry_run "mv /sdcard/$continue_boot_img_filename /sdcard/$sdcard_boot_img_name"
		else
			mv /sdcard/$continue_boot_img_filename /sdcard/$sdcard_boot_img_name
		fi
	else
		msg "New SD card image will not be renamed when switch_fw is enabled"
	fi
else
	{ msg "/sdcard/$continue_boot_img_filename file is missing" ; return 1 ; }
fi

