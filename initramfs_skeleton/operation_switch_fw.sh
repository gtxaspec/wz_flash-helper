#!/bin/sh
#
#  ____          _ _       _        __                                       _   _             
# / ___|_      _(_) |_ ___| |__    / _|_      __   ___  _ __   ___ _ __ __ _| |_(_) ___  _ __  
# \___ \ \ /\ / / | __/ __| '_ \  | |_\ \ /\ / /  / _ \| '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \ 
#  ___) \ V  V /| | || (__| | | | |  _|\ V  V /  | (_) | |_) |  __/ | | (_| | |_| | (_) | | | |
# |____/ \_/\_/ |_|\__\___|_| |_| |_|   \_/\_/    \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|
#                                                      |_|                                     


                    
function flash_backup_stock_boot_part() {
# Description: Flash boot partition with backup boot image
	flashcp /boot_backup.img /dev/mtd0 || return 1
}

function rollback_stock_boot_part() {
# Description: Check if written OpenIPC boot partition is valid, if not, rollback to stock boot image
	msg "ATTENTION! ATTENTION! ATTENTION!"
	msg "ATTENTION! ATTENTION! ATTENTION!"
	msg "ATTENTION! ATTENTION! ATTENTION!"
	msg
	msg "It is very likely that your boot partition is corrupted as it hash does not match any of known good OpenIPC boot image hashes"
	msg "Rolling back boot partition with previous stock boot image"
	msg
	if flash_backup_stock_boot_part; then
		msg "Rollback succeeded :) You are safe now!"
	else
		msg "Rollback failed :( Trying rolling back one more time"
		flash_backup_stock_boot_part && msg "This time rollback succeeded :)" || { msg "Rollback failed again, sorry" ; return 1 ; }
	fi
}

function switch_fw_openipc_failsafe() {
	msg "Checking if your OpenIPC boot partitiion is corrupted"
	if source /suboperation_switch_fw_validate_openipc_boot.sh ; then
		msg "OpenIPC boot partition has been written correctly"
	else
		rollback_stock_boot_part || { msg "Your flash chip seems to be corrupted :'(" ; return 1 ; }
	fi
}
                                                                                            
function switch_fw_operation() {
	[[ "$restore_partitions" == "yes" ]] && { msg "Restore and Switch_fw operations are conflicted, please enable only one option at a time" ; return 1 ; }

	[[ "$current_fw" == "$switch_fw_to" ]] && { msg "switch_fw_to value is same as current firmware type, aborting switch firmware" ; return 1 ; }
	
	/bg_blink_led_red_and_blue.sh &
	local red_and_blue_leds_pid="$!"
	msg
	msg "---------- Begin of switch fw ----------"
	if [[ "$current_fw" == "stock" ]] && [[ "$switch_fw_to" == "openipc" ]]; then
		msg "Switching from stock firmware to OpenIPC"
		source /suboperation_switch_fw_to_openipc.sh || return 1
	
	elif [[ "$current_fw" == "openipc" ]] && [[ "$switch_fw_to" == "stock" ]] && [[ "$chip_family" == "t20" ]]; then
		msg "Switching from OpenIPC firmware to T20 stock"
		source /suboperation_switch_fw_openipc_to_t20.sh || return 1
	
	elif [[ "$current_fw" == "openipc" ]] && [[ "$switch_fw_to" == "stock" ]] && [[ "$chip_family" == "t31" ]]; then
		msg "Switching from OpenIPC firmware to T31 stock"
		source /suboperation_switch_fw_openipc_to_t31.sh || return 1
	
	fi
	
	if [[ "$current_fw" ]] && [[ "$switch_fw_to" == "openipc" ]]; then
		if [[ "$dry_run" == "yes" ]]; then
			msg "No need to check for OpenIPC boot partition curruption on dry run mode"
		else
			switch_fw_openipc_failsafe
		fi
	fi
	kill $red_and_blue_leds_pid
	msg
}

switch_fw_operation || return 1

