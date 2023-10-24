#!/bin/sh
#
#   __  __ _             __                  _   _                 
#  |  \/  (_)___  ___   / _|_   _ _ __   ___| |_(_) ___  _ __  ___ 
#  | |\/| | / __|/ __| | |_| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#  | |  | | \__ \ (__  |  _| |_| | | | | (__| |_| | (_) | | | \__ \
#  |_|  |_|_|___/\___| |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#                                                                 

function move_continue_boot_img_file() {
# Description: Rename SD card boot image that will be booted next boot
	if [[ "$enable_continue_boot_img" == "yes" ]]; then
		msg "enable_continue_boot_img value is Yes"
		case "$current_fw_type" in
			"stock")
				msg "Renaming /sdcard/$continue_boot_img_filename to /sdcard/factory_t31_ZMC6tiIDQN"
				mv /sdcard/$continue_boot_img_filename /sdcard/factory_t31_ZMC6tiIDQN
				;;
			"openipc")
				msg "Renaming /sdcard/$continue_boot_img_filename to /sdcard/factory_0P3N1PC_kernel"
				mv /sdcard/$continue_boot_img_filename /sdcard/factory_0P3N1PC_kernel
				;;
		esac
	else
		msg "enable_continue_boot_img value is No"
	fi
}

function move_flash_tool_boot_img_file() {
# Description: Rename the SD card boot image to avoid infinite boot loop
	case "$current_fw_type" in
		"stock")
			msg "Renaming /sdcard/factory_t31_ZMC6tiIDQN to /sdcard/factory_t31_ZMC6tiIDQN.$flash_tool_name"
			mv /sdcard/factory_t31_ZMC6tiIDQN /sdcard/factory_t31_ZMC6tiIDQN.$flash_tool_name
			;;
		"openipc")
			msg "Renaming /sdcard/factory_0P3N1PC_kernel to /sdcard/factory_0P3N1PC_kernel.$flash_tool_name"
			mv /sdcard/factory_0P3N1PC_kernel /sdcard/factory_0P3N1PC_kernel.$flash_tool_name
			;;
	esac
}


function get_boot_part_hash() {
# Description: Calculate md5 hash of current boot partition
	dd if=$boot_partmtd of=/boot_partimg_new
	boot_partimg_md5_new=$(md5sum /tmp/boot_partimg_new)
	rm /boot_partimg_new
}

function check_valid_openipc_boot_part() {
# Description: Check if flashed OpenIPC boot partition hash is on the valid hash list
	msg "Checking if your boot partitiion is corrupted"

	case "$chip_family" in
		"t20") openipc_good_boot_hash_list="$t20_valid_hashes" ;;
		"t31") openipc_good_boot_hash_list="$t31_valid_hashes" ;;
	esac
	
	get_boot_part_hash
	if echo "$openipc_good_boot_hash_list" | grep -q $boot_partimg_md5_new ; then
		return 0
	else
		msg "md5 check for valid OpenIPC boot partition failed"
	fi
	
	get_boot_part_hash
	if ! echo "$openipc_good_boot_hash_list" | grep -q $boot_partimg_md5_new ; then
		msg "md5 check for valid OpenIPC boot partition failed second time"
	else
		return 0
	fi
	
	get_boot_part_hash
	if ! echo "$openipc_good_boot_hash_list" | grep -q $boot_partimg_md5_new ; then
		{ msg "md5 check for valid OpenIPC boot partition failed third time" ; return 1 ; }
	else
		return 0
	fi
}

function rollback_stock_boot_part() {
# Description: Flash boot partition with old boot image
	flashcp /boot_partimg $boot_partmtd
}

function rollback_stock_boot_part_if_openipc_boot_flash_fails() {
# Description: Check if flashed OpenIPC boot partition is valid, if not, rollback to stock boot image
	if ! check_valid_openipc_boot_part ; then
		msg "ATTENTION! ATTENTION! ATTENTION!"
		msg "ATTENTION! ATTENTION! ATTENTION!"
		msg "ATTENTION! ATTENTION! ATTENTION!"
		msg
		msg "It is very likely that your boot partition is corrupted as it hash does not match any of known good OpenIPC boot image hashes"
		msg "Rolling back boot partition with stock boot image"
		msg
		if rollback_boot_part; then
			msg "Rollback succeeded :) You are safe now!"
		else
			msg "Rollback failed :( Trying rolling back one more time"
			rollback_boot_part || msg "Rollback failed again, sorry, you need to rescure your flash chip with a programmer" && msg "This time rollback succeeded :)"
		fi
	else
		msg "Your boot partition is okay :)"
	fi
}

