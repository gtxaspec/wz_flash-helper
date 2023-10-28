#!/bin/sh
#
#  ____           _                                              _   _             
# |  _ \ ___  ___| |_ ___  _ __ ___    ___  _ __   ___ _ __ __ _| |_(_) ___  _ __  
# | |_) / _ \/ __| __/ _ \| '__/ _ \  / _ \| '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \ 
# |  _ <  __/\__ \ || (_) | | |  __/ | (_) | |_) |  __/ | | (_| | |_| | (_) | | | |
# |_| \_\___||___/\__\___/|_|  \___|  \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|
#                                          |_|                                     

function restore_current_profile_parts() {
# Description: Restore OpenIPC partitions from partition images
	for partname in $current_profile_restore_partname_list; do
		local infile_name=$(get_current_profile_partimg $partname)
		local infile="$current_profile_restore_path/$infile_name"
		local partmtd=$(get_current_profile_partmtd $partname)
		local restore_opt_value=$(get_current_profile_restore_opt_value $partname)
		
		if [[ "${current_profile}_${restore_opt_value}" == "yes" ]]; then
			msg "${current_profile}_${restore_opt_value} value is Yes"
			restore_partition $partname $infile $partmtd || { msg "Restore $infile to $partname partition failed" ; return 1 ; }
		else
			msg "${current_profile}_${restore_opt_value} value is No"
		fi
	done
}


function restore_operation() {

	[[ "$switch_profile" == "yes" ]] && { msg "Restore and Switch_profile operations are conflicted, please enable only one option at a time" ; return 1 ; }
	
	[[ ! "$current_profile" == "$restore_profile_type" ]] && { msg "restore_profile_type mismatches with current firmware type, aborting" ; return 1 ; }

	[ ! -d $current_profile_restore_path ] && { msg "$current_profile_restore_path directory is missing" ; return 1 ; }
	
	/bg_blink_led_red.sh &
	local red_led_pid="$!"
	msg
	msg "---------- Begin of restore operation ----------"
	restore_current_profile_parts
	kill $red_led_pid
	msg
}


restore_operation || return 1
