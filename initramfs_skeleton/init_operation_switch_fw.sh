#!/bin/sh
#
#  ____          _ _       _        __                                       _   _             
# / ___|_      _(_) |_ ___| |__    / _|_      __   ___  _ __   ___ _ __ __ _| |_(_) ___  _ __  
# \___ \ \ /\ / / | __/ __| '_ \  | |_\ \ /\ / /  / _ \| '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \ 
#  ___) \ V  V /| | || (__| | | | |  _|\ V  V /  | (_) | |_) |  __/ | | (_| | |_| | (_) | | | |
# |____/ \_/\_/ |_|\__\___|_| |_| |_|   \_/\_/    \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|
#                                                      |_|                                     


                    
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

                                                                                            
function switch_fw_operation() {
	[[ "$restore_partitions" == "yes" ]] && { msg "Restore and Switch_fw operation are conflicted, please enable only one option at a time" ; exit_init ; }

	if [[ "$current_fw_type" == "$switch_fw_to" ]]; then
		{ msg "switch_fw_to value is same as current firmware type, aborting firmware switch" ; exit_init ; }
	fi
	
	/blink_led_red_and_blue.sh &
	red_and_blue_leds_pid="$!"
	if [[ "$current_fw_type" == "stock" ]] && [[ "$switch_fw_to" == "openipc" ]]; then
		msg "Switching from stock firmware to OpenIPC"
		switch_fw_stock_to_openipc
	
	elif [[ "$current_fw_type" == "stock" ]] && [[ "$switch_fw_to" == "stock" ]] && [[ "$chip_family" == "t20" ]]; then
		msg "Switching from OpenIPC firmware to T20 stock"
		switch_fw_openipc_to_t20_stock
	
	elif [[ "$current_fw_type" == "stock" ]] && [[ "$switch_fw_to" == "stock" ]] && [[ "$chip_family" == "t31" ]]; then
		msg "Switching from OpenIPC firmware to T31 stock"
		switch_fw_openipc_to_t31_stock
	
	fi
	kill $red_and_blue_leds_pid
}

switch_fw_operation
