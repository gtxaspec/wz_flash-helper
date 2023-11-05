#!/bin/sh
#
#  ____           _                                              _   _             
# |  _ \ ___  ___| |_ ___  _ __ ___    ___  _ __   ___ _ __ __ _| |_(_) ___  _ __  
# | |_) / _ \/ __| __/ _ \| '__/ _ \  / _ \| '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \ 
# |  _ <  __/\__ \ || (_) | | |  __/ | (_) | |_) |  __/ | | (_| | |_| | (_) | | | |
# |_| \_\___||___/\__\___/|_|  \___|  \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|
#                                          |_|                                     

function restore_current_profile_bootpart() {
# Description: Restore boot partition, this option is hidden from restore config files
	if [[ "$hidden_option_restore_boot" == "yes" ]]; then
		msg "- Sssh! Restoring boot option"
		local partname="boot"
		local infile_name=$(get_current_profile_partimg $partname)
		local infile="$current_profile_restore_path/$infile_name"
		local partmtd=$(get_current_profile_partmtd $partname)
		
		restore_partition $partname $infile $partmtd || { msg "Restore $infile to $partname partition failed" ; return 1 ; }
	fi
}

function restore_current_profile_parts() {
# Description: Restore partitions from partition images
	for partname in $current_profile_restore_partname_list; do
		local infile_name=$(get_current_profile_partimg $partname)
		local infile="$current_profile_restore_path/$infile_name"
		local partmtd=$(get_current_profile_partmtd $partname)
		local restore_opt_value=$(get_current_profile_restore_opt_value $partname)
		
		if [[ "$restore_opt_value" == "yes" ]]; then
			msg "[x] restore_${current_profile}_${partname} value is Yes"
			restore_partition $partname $infile $partmtd || { msg "Restore $infile to $partname partition failed" ; return 1 ; }
		else
			msg "[ ] restore_${current_profile}_${partname} value is No"
		fi
	done
}


function restore_operation() {
	[[ "$switch_profile" == "yes" ]] && { msg "Restore and Switch_profile operations are conflicted, please enable only one option at a time" ; return 1 ; }
	[ ! -d $current_profile_restore_path ] && { msg "$current_profile_restore_path directory is missing" ; return 1 ; }
	[ ! -f $prog_restore_config_file ] && { msg "$prog_restore_config_file file is missing. Nothing more will be done" ; return 1 ; }	

	dos2unix $prog_restore_config_file && source $prog_restore_config_file || { msg "$prog_restore_config_file file is invalid. Nothing will be done" ; return 1 ; }

	/bg_blink_led_red.sh &
	local red_led_pid="$!"
	msg
	msg "---------- Begin of restore operation ----------"
	msg "Restore source: $current_profile_restore_path"
	msg
	restore_current_profile_parts
	restore_current_profile_bootpart
	sync
	msg "----------- End of restore operation -----------"
	msg
	kill $red_led_pid
	/bg_turn_off_leds.sh
}


restore_operation || return 1
