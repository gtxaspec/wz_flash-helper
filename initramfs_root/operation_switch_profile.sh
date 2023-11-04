#!/bin/sh
#
#  ____          _ _       _                        __ _ _                                   _   _             
# / ___|_      _(_) |_ ___| |__    _ __  _ __ ___  / _(_) | ___    ___  _ __   ___ _ __ __ _| |_(_) ___  _ __  
# \___ \ \ /\ / / | __/ __| '_ \  | '_ \| '__/ _ \| |_| | |/ _ \  / _ \| '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \ 
#  ___) \ V  V /| | || (__| | | | | |_) | | | (_) |  _| | |  __/ | (_) | |_) |  __/ | | (_| | |_| | (_) | | | |
# |____/ \_/\_/ |_|\__\___|_| |_| | .__/|_|  \___/|_| |_|_|\___|  \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|
#                                 |_|                                  |_|                                     



function validate_restore_partition_images() {
	msg "- Making sure that all needed partition images exist and are valid"
	cd $next_profile_images_path
	for partname in $next_profile_all_partname_list; do # Check md5 for all partitions first to make sure they are all valid before flashing each partition
		if [[ "$(get_next_profile_partoperation $partname)" == "write" ]]; then
			local infile_name=$(get_next_profile_partimg $partname)
			[ ! -f $infile_name ] && { msg " + $infile_name file is missing" ; return 1 ; }
			
			msg_nonewline " + Verifying $infile_name... "
			md5sum -c $infile_name.md5sum && msg "ok" || { msg "failed" ; return 1 ; }
		fi
	done
	msg
}

function validate_written_bootpart() {
# Description: Check 3 times if written boot partition is the same as the partition image used to write
	msg
	msg "- Validating written boot partition"
	for attempt in 1 2 3; do
		msg "- Validation attempt $attempt:"
		local bootimg_name=$(get_next_profile_partimg "boot")
		local bootimg="$next_profile_images_path/$bootimg_name"
		local bootimg_blocksize=$(du -b $bootimg | cut -f -1)
		local bootimg_hash=$(md5sum $bootimg | cut -d ' ' -f1)
		msg " + Boot image used to write hash: $bootimg_hash"

		dd if=/dev/mtd0 of=/bootpart_check.img bs=1 count=$bootimg_blocksize status=none
		local bootpart_hash=$(md5sum /bootpart_check.img | cut -d ' ' -f1)		
		msg " + Current boot partition hash: $bootpart_hash"

		rm /bootpart_check.img	

		msg_nonewline " + Validation result: "
		[[ "$bootimg_hash" == "$bootpart_hash" ]] && { msg "ok" ; return 0 ; } || msg "failed"
	done
	rm /bootpart_check.img
	return 1
}

function rollback_bootpart() {
# Description: Check if written boot partition is valid, if not, rollback with backup boot image
	msg
	msg "ATTENTION! ATTENTION! ATTENTION!"
	msg "ATTENTION! ATTENTION! ATTENTION!"
	msg "ATTENTION! ATTENTION! ATTENTION!"
	msg
	msg "It is very likely that your boot partition is corrupted"
	msg "Rolling back boot partition with previous profile boot image"
	msg
	
	for attempt in 1 2; do
		msg "- Rollback attempt $attempt:"
		msg_nonewline " + Rollback result: "
		restore_partition "boot" /bootpart_backup.img /dev/mtd0 && { msg "succeeded :) You are safe now!" ; return 1 ; } || msg "failed"
	done
		
	msg "Rollback failed twice, sorry. Probably your flash chip is corrupted"
	return 1
}

function switch_profile_operation() {
	[[ "$restore_partitions" == "yes" ]] && { msg "Restore and Switch_profile operations are conflicted, please enable only one option at a time" ; return 1 ; }
	[[ "$current_profile" == "$next_profile" ]] && { msg "next_profile value is same as current_profile, aborting switch profile" ; return 1 ; }
	[ ! -d /profile.d/$chip_family/$next_profile ] && { msg "next_profile is not supported, aborting switch profile" ; return 1 ; }
	
	source /profile.d/$chip_family/$next_profile/next_profile_variables.sh
	source /profile.d/$chip_family/$next_profile/next_profile_queries.sh
	
	if [[ "$switch_profile_with_all_partitions" == "yes" ]]; then
		source /profile.d/$chip_family/$next_profile/next_profile_switch_allparts.sh
	else
		source /profile.d/$chip_family/$next_profile/next_profile_switch_baseparts.sh
	fi
	
	/bg_blink_led_red_and_blue.sh &
	local red_and_blue_leds_pid="$!"
	msg
	msg "---------- Begin of switch profile ----------"
	msg "Switch profile: $current_profile -> $next_profile"
	msg "Source directory: $next_profile_images_path"
	msg
	validate_restore_partition_images || return 1
	
	msg "- Writing to partitions"
	for partname in $next_profile_all_partname_list; do
		local partoperation=$(get_next_profile_partoperation $partname)
		local partmtd=$(get_next_profile_partmtd $partname)
		
		case "$partoperation" in
			"write")
				local infile_name=$(get_next_profile_partimg $partname)
				local infile="$next_profile_images_path/$infile_name"
				restore_partition $partname $infile $partmtd || { msg "Failed to write $partname partition image, aborting profile switch" ; return 1 ; }
				;;
			"erase")
				erase_partition $partname $partmtd || return 1
				;;
			"format")
				local partfstype=$(get_next_profile_partfstype $partname)
				local partmtd=$(get_next_profile_partmtd $partname)
				local partmtdblock=$(get_next_profile_partmtdblock $partname)
				
				case $partfstype in
					"jffs2")
						format_partition_jffs2 $partname $partmtd || { msg "Failed to format partition $partname as jffs2" ; return 1 ; }
						;;
					"vfat")
						format_partition_vfat $partname $partmtdblock || { msg "Failed to format partition $partname as vfat" ; return 1 ; }
						;;
					*)
						msg "- Formating partition $partname as $partfstype is not supported"
						return 1
						;;
				esac
				;;
			"leave")
				leave_partition $partname $partmtd
				;;
		esac
	done
	
	[[ "$dry_run" == "yes" ]] && { msg "- No need to check for boot partition corruption on dry run mode" ; return 0 ; }
	validate_written_bootpart || { 	msg " + Boot partition validation failed" ; rollback_bootpart ; } || return 1
	msg "----------- End of switch profile -----------"
	msg
	kill $red_and_blue_leds_pid
}

switch_profile_operation || return 1
