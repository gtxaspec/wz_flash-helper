#!/bin/sh
#
#  ____           _                                              _   _             
# |  _ \ ___  ___| |_ ___  _ __ ___    ___  _ __   ___ _ __ __ _| |_(_) ___  _ __  
# | |_) / _ \/ __| __/ _ \| '__/ _ \  / _ \| '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \ 
# |  _ <  __/\__ \ || (_) | | |  __/ | (_) | |_) |  __/ | | (_| | |_| | (_) | | | |
# |_| \_\___||___/\__\___/|_|  \___|  \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|
#                                          |_|                                     



function or_restore_boot_partition() {
# Description: Restore the boot partition, this option is hidden from restore config files
	if [[ "$hidden_option_restore_boot" == "yes" ]]; then
		msg "- Sssh! Restoring boot option"
		local partname="boot"
		local infile_name=$(get_cp_partimg $partname)
		local infile="$cp_restore_path/$infile_name"
		local partmtd=$(get_cp_partmtd $partname)
		local partmtdblock=$(get_cp_partmtdblock $partname)
		
		write_partition $partname $infile $partmtd || { msg "Restore $infile to $partname partition failed" ; return 1 ; }
		
		validate_written_partition $partname $partmtdblock $infile || rollback_boot_partition || return 1
	fi
}

function or_restore_partitions() {
# Description: Restore partitions from partition images
	for partname in $cp_restore_partname_list; do
		local infile_name=$(get_cp_partimg $partname)
		local infile="$cp_restore_path/$infile_name"
		local partmtd=$(get_cp_partmtd $partname)
		local restore_opt_value=$(get_cp_restore_opt_value $partname)
		
		if [[ "$restore_opt_value" == "yes" ]]; then
			msg "[x] restore_${current_profile}_${partname} value is Yes"
			write_partition $partname $infile $partmtd || { msg "Restore $infile to $partname partition failed" ; return 1 ; }
		else
			msg "[ ] restore_${current_profile}_${partname} value is No"
		fi
	done
}

function operation_restore() {
	[[ "$switch_profile" == "yes" ]] && { msg "Restore and Switch_profile operations are conflicted, please enable only one option at a time" ; return 1 ; }
	[ ! -d $cp_restore_path ] && { msg "$cp_restore_path directory is missing" ; return 1 ; }
	[ ! -f $prog_restore_config_file ] && { msg "$prog_restore_config_file file is missing. Nothing more will be done" ; return 1 ; }	

	dos2unix $prog_restore_config_file && source $prog_restore_config_file || { msg "$prog_restore_config_file file is invalid. Nothing will be done" ; return 1 ; }

	/bg_blink_led_red.sh &
	local red_led_pid="$!"
	msg
	msg "---------- Begin of restore operation ----------"
	msg "Restore source: $cp_restore_path"
	msg
	or_restore_boot_partition
	or_restore_partitions
	sync
	msg "----------- End of restore operation -----------"
	msg
	kill $red_led_pid
	/bg_turn_off_leds.sh
}

operation_restore || return 1
