#!/bin/sh
# Description: Rename SD card boot image that will be booted next boot



if [[ ! "$switch_fw" == "yes" ]]; then
	msg "Renaming /sdcard/$continue_boot_img_filename to /sdcard/factory_t31_ZMC6tiIDQN"
	mv /sdcard/$continue_boot_img_filename /sdcard/factory_t31_ZMC6tiIDQN
fi

