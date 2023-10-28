#!/bin/sh
#
#  ____          _ _       _                        __ _ _                                   _   _             
# / ___|_      _(_) |_ ___| |__    _ __  _ __ ___  / _(_) | ___    ___  _ __   ___ _ __ __ _| |_(_) ___  _ __  
# \___ \ \ /\ / / | __/ __| '_ \  | '_ \| '__/ _ \| |_| | |/ _ \  / _ \| '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \ 
#  ___) \ V  V /| | || (__| | | | | |_) | | | (_) |  _| | |  __/ | (_) | |_) |  __/ | | (_| | |_| | (_) | | | |
# |____/ \_/\_/ |_|\__\___|_| |_| | .__/|_|  \___/|_| |_|_|\___|  \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|
#                                 |_|                                  |_|                                     



function validate_restore_partition_images() {
	msg " - Making sure that all needed partition images present and are valid"
	cd $next_profile_images_path
	for partname in $next_profile_all_partname_list; do # Check md5 for all partitions first to make sure they are all valid before flashing each partition
		if [[ "$(get_next_profile_switch_profile_all $partname)" == "write" ]]; then
			local infile_name=$(get_next_profie_partimg $partname)
			msg_nonewline " + Verifying $infile_name... "
			md5sum -c $infile_name.md5sum && msg "ok" || { msg "failed" ; return 1 ; }
		fi
	done
	
	if [ -f /profile.d/$next_profile/boot_hashes.txt ]; then
		msg "Found valid boot partition image hashes, validating boot"
		local boot_img_name=$(get_next_profile_partimg boot)
		local boot_img="$next_profile_restore_dir_path/$boot_img_name"
		local boot_img_hash=$(md5sum $boot_img | cut -d ' ' -f1)
	
		echo "$valid_hashes" | grep -q $boot_part_hash && msg "ok" || { msg "failed" ; return 1 ; }
	fi
}

function validate_written_bootpart() {
# Description: Check 3 times if written boot partition hash is on the valid hash list
	msg " + Validating written boot partition... "
	for count in 1 2 3; do
		msg " + Attempt $count: "
		backup_partition boot /dev/mtd0 /boot_part_check.img
		local boot_part_hash=$(md5sum /boot_part_check.img | cut -d ' ' -f1)
		rm /boot_part_check.img
		echo "$valid_hashes" | grep -q $boot_part_hash && { msg "ok" ; break ; return 0 ; } || msg "failed"
	done
	return 1
}

function rollback_stock_boot_part() {
# Description: Check if written boot partition is valid, if not, rollback to stock boot image
	msg
	msg "ATTENTION! ATTENTION! ATTENTION!"
	msg "ATTENTION! ATTENTION! ATTENTION!"
	msg "ATTENTION! ATTENTION! ATTENTION!"
	msg
	msg "It is very likely that your boot partition is corrupted as it hash does not match any of known good boot image hashes"
	msg "Rolling back boot partition with previous profile boot image"
	msg
	
	for count in 1 2; do
		msg_nonewline " + Rolling back attempt $count... "
		restore_partition "boot" /bootpart_backup.img /dev/mtd0 && { msg "succeeded :) You are safe now!" ; break ; return 0 ; } || msg "failed"
	done
		
	msg "Rollback failed twice, sorry. Probably your flash chip is corrupted"
	return 1
}

function switch_profile_operation() {
	[[ "$restore_partitions" == "yes" ]] && { msg "Restore and Switch_profile operations are conflicted, please enable only one option at a time" ; return 1 ; }
	[[ "$current_profile" == "$next_profile" ]] && { msg "next_profile value is same as current profile, aborting switch profile" ; return 1 ; }

	/bg_blink_led_red_and_blue.sh &	
	local red_and_blue_leds_pid="$!"
	msg
	msg "---------- Begin of switch profile ----------"
	validate_restore_partition_images
	for partname in $next_profile_all_partname_list; do
		local partname_task=$(get_next_profile_partoperation $partname)
		local partmtd=$(get_next_profile_partmtd $partname)
		
		case "$partname_task" in
			"write")
				local infile_name=$(get_next_profile_partimg $partname)
				local infile="$next_profile_images_path/$infile_name"
				restore_partition $partname $infile $partmtd || { msg "Failed to write $partname partition image, aborting profile switch" ; return 1 ; }
				;;
			"erase")
				erase_partition $partname $partmtd || return 1
				;;
			"leave")
				leave_partition $partname $partmtd
				;;
		esac
	done
	
	[[ "$dry_run" == "yes" ]] && { msg " + No need to check for boot partition curruption on dry run mode" ; return 0 ; }
	validate_written_bootpart || { 	msg " + Boot partition validation failed" ; rollback_bootpart ; } || return 1
	kill $red_and_blue_leds_pid
}

switch_profile_operation || return 1
