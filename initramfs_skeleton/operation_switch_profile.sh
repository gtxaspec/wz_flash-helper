#!/bin/sh
#
#  ____          _ _       _        __                                       _   _             
# / ___|_      _(_) |_ ___| |__    / _|_      __   ___  _ __   ___ _ __ __ _| |_(_) ___  _ __  
# \___ \ \ /\ / / | __/ __| '_ \  | |_\ \ /\ / /  / _ \| '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \ 
#  ___) \ V  V /| | || (__| | | | |  _|\ V  V /  | (_) | |_) |  __/ | | (_| | |_| | (_) | | | |
# |____/ \_/\_/ |_|\__\___|_| |_| |_|   \_/\_/    \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|
#                                                      |_|                                     



function validate_restore_partition_images() {
	msg " - Making sure that all needed partition images present and are valid"
	cd $next_profile_images_path
	for partname in $next_profile_all_partname_list; do # Check md5 for all partitions first to make sure they are all valid before flashing each partition
		if [[ "$(get_next_profile_switch_profile_all $partname)" == "write" ]]; then
			local infile_name=$(get_openipc_partimg $partname)
			msg_nonewline " + Verifying $infile_name... "
			md5sum -c $infile_name.md5sum && msg "ok" || { msg "failed" ; return 1 ; }
		fi
	done
	
	[ ! -f /firmware_profile.d/$next_profile/$current_profile.txt ] && exit 0

	msg "Found valid boot partition image hashes, validating boot"
	local boot_img_name=$(get_openipc_partimg boot)
	local boot_img="$openipc_restore_dir_path/$boot_img_name"
	local boot_img_hash=$(md5sum $boot_img | cut -d ' ' -f1)
	
	echo "$valid_hashes" | grep -q $boot_part_hash && msg "ok" || { msg "failed" ; return 1 ; }
	
}

function sub_validate_written_bootpart() {

	dd if=/dev/mtd0 of=/boot_part_check.img
	
	local boot_part_hash=$(md5sum /boot_part_check.img | cut -d ' ' -f1)
	rm /boot_part_check.img
	
	echo "$valid_hashes" | grep -q $boot_part_hash || return 1
}

function validate_written_openipc_bootpart() {
# Description: Check if written OpenIPC boot partition hash is on the valid hash list
	msg_nonewline " + Validating written OpenIPC boot partition... "
	sub_validate_written_bootpart && return 0 || msg_nonewline "failed... "
	sub_validate_written_bootpart && return 0 || msg_nonewline "failed the second time... "
	sub_validate_written_bootpart && return 0 || msg "failed the third time"
	msg " + OpenIPC boot partition validation failed three times"
	exit 1
}

function flash_backup_stock_boot_part() {
# Description: Flash boot partition with backup boot image
	flashcp /boot_backup.img /dev/mtd0 || return 1
}

function rollback_stock_boot_part() {
# Description: Check if written OpenIPC boot partition is valid, if not, rollback to stock boot image
	msg
	msg "ATTENTION! ATTENTION! ATTENTION!"
	msg "ATTENTION! ATTENTION! ATTENTION!"
	msg "ATTENTION! ATTENTION! ATTENTION!"
	msg
	msg "It is very likely that your boot partition is corrupted as it hash does not match any of known good OpenIPC boot image hashes"
	msg "Rolling back boot partition with previous stock boot image"
	msg
	
	flash_backup_stock_boot_part && { msg "Rollback succeeded :) You are safe now!" ; return 0 ; }
	flash_backup_stock_boot_part && { msg "This time rollback succeeded :)" ; return 0 ; }
	
	msg "Rollback failed again, sorry"
	return 1
}

function switch_profile_openipc_failsafe() {
	msg " + Checking if your OpenIPC boot partitiion is corrupted"
	if source /suboperation_switch_profile_validate_openipc_boot.sh ; then
		msg " + OpenIPC boot partition has been written correctly"
	else
		rollback_stock_boot_partpart || return 1
	fi
}

function switch_profile_operation() {
	[[ "$restore_partitions" == "yes" ]] && { msg "Restore and Switch_profile operations are conflicted, please enable only one option at a time" ; return 1 ; }

	[[ "$current_profile" == "$switch_profile_to" ]] && { msg "switch_profile_to value is same as current firmware type, aborting switch firmware" ; return 1 ; }
	
	if [ -f /firmware_profile.d/$next_profile/$current_profile.txt ]; then
		msg "Found valid boot partition image hashes"
		validate_boot_flag="true"
		valid_boot_hashes=$(cat /firmware_profile.d/$next_profile/$current_profile.txt)
	fi
	
	/bg_blink_led_red_and_blue.sh &
	local red_and_blue_leds_pid="$!"
	msg
	msg "---------- Begin of switch profile ----------"

	for partname in $next_profile_all_partname_list; do
		local partname_task=$(get_next_profile_partoperation $partname)
		local partmtd=$(get_next_profile_partmtd $partname)
		
		case "$partname_task" in
			"write")
				local infile_name=$(get_next_profile_partimg $partname)
				local infile="$next_profile_images_path/$infile_name"
				restore_partition $partname $infile $partmtd || { msg "Failed to write $partname partition image, aborting firmware switch" ; return 1 ; }
				;;
			"erase")
				erase_partition $partname $partmtd || return 1 ;;
			"leave")
				leave_partition $partname $partmtd ;;
		esac
	done

	[[ "$dry_run" == "yes" ]] && { msg " + No need to check for boot partition curruption on dry run mode" ; kill $red_and_blue_leds_pid ; return 0 ; }
	switch_profile_openipc_failsafe
	kill $red_and_blue_leds_pid
	msg
}

switch_profile_operation || return 1
validate_openipc_bootimg || return 1
switch_profile_stock_to_openipc || return 1
validate_written_openipc_bootpart || return 1




