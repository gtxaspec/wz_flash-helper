#!/bin/sh
#
#  ____          _ _       _                        __ _ _                                   _   _             
# / ___|_      _(_) |_ ___| |__    _ __  _ __ ___  / _(_) | ___    ___  _ __   ___ _ __ __ _| |_(_) ___  _ __  
# \___ \ \ /\ / / | __/ __| '_ \  | '_ \| '__/ _ \| |_| | |/ _ \  / _ \| '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \ 
#  ___) \ V  V /| | || (__| | | | | |_) | | | (_) |  _| | |  __/ | (_) | |_) |  __/ | | (_| | |_| | (_) | | | |
# |____/ \_/\_/ |_|\__\___|_| |_| | .__/|_|  \___/|_| |_|_|\___|  \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|
#                                 |_|                                  |_|                                     



function osp_validate_restore_partition_images() {
	msg "- Making sure that all needed partition images exist and are valid"
	
	cd $np_images_path
	
	# Check sha256 for all partitions first to make sure they are all valid before flashing each partition
	for partname in $np_all_partname_list; do 
		if [[ "$(get_np_partoperation $partname)" == "write" ]]; then
			local infile_name=$(get_np_partimg $partname)
	
			[ ! -f $infile_name ] && { msg " + $infile_name file is missing" ; return 1 ; }
			
			msg_nonewline " + Verifying $infile_name... "
			sha256sum -c $infile_name.sha256sum && msg "ok" || { msg "failed" ; return 1 ; }
		fi
	done
	msg
}

function osp_validate_written_boot_partition() {
# Description: Validate if the written boot partition is the same as the boot partition image used to write
	local partname="boot"
	local partmtdblock=$(get_np_partmtdblock $partname)
	local verifyfile_basename=$(get_np_partimg $partname)
	local verifyfile="$np_images_path/$verifyfile_basename"
	
	validate_written_partition $partname $partmtdblock $verifyfile || return 1
}

function operation_switch_profile() {
	[[ "$restore_partitions" == "yes" ]] && { msg "Restore and Switch_profile operations are conflicted, please enable only one option at a time" ; return 1 ; }
	[[ "$current_profile" == "$next_profile" ]] && { msg "next_profile value is same as current_profile, aborting switch profile" ; return 1 ; }
	[ ! -d /profile.d/$chip_family/$next_profile ] && { msg "next_profile is not supported, aborting switch profile" ; return 1 ; }
	
	source /profile.d/$chip_family/$next_profile/np_variables.sh
	source /profile.d/$chip_family/$next_profile/np_queries.sh
	
	if [[ "$switch_profile_with_all_partitions" == "yes" ]]; then
		source /profile.d/$chip_family/$next_profile/np_switch_allparts.sh
	else
		source /profile.d/$chip_family/$next_profile/np_switch_baseparts.sh
	fi
	
	/bg_blink_led_red_and_blue.sh &
	local red_and_blue_leds_pid="$!"
	msg
	msg "---------- Begin of switch profile ----------"
	msg "Switch profile: $current_profile -> $next_profile"
	msg "Source directory: $np_images_path"
	msg
	osp_validate_restore_partition_images || return 1
	
	msg "- Writing to partitions"
	for partname in $np_all_partname_list; do
		local partoperation=$(get_np_partoperation $partname)
		local partmtd=$(get_np_partmtd $partname)
		
		case "$partoperation" in
			"write")
				local infile_name=$(get_np_partimg $partname)
				local infile="$np_images_path/$infile_name"
				write_partition $partname $infile $partmtd || return 1
				;;
			"erase")
				erase_partition $partname $partmtd || return 1
				;;
			"format")
				local partfstype=$(get_np_partfstype $partname)
				local partnum=$(get_np_partnum $partname)
				format_partition $partname $partnum $partfstype || return 1
				;;
			"leave")
				leave_partition $partname $partmtd
				;;
		esac
	done
	msg
	[[ "$dry_run" == "yes" ]] && { msg "- No need to check for boot partition corruption on dry run mode" ; return 0 ; }
	osp_validate_written_boot_partition || rollback_boot_partition || return 1
	sync
	msg "----------- End of switch profile -----------"
	msg
	kill $red_and_blue_leds_pid
	/bg_turn_off_leds.sh
}

operation_switch_profile || return 1
