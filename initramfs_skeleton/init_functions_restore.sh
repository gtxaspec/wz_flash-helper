#!/bin/sh
#
#    ____           _                    __                  _   _                 
#   |  _ \ ___  ___| |_ ___  _ __ ___   / _|_   _ _ __   ___| |_(_) ___  _ __  ___ 
#   | |_) / _ \/ __| __/ _ \| '__/ _ \ | |_| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#   |  _ <  __/\__ \ || (_) | | |  __/ |  _| |_| | | | | (__| |_| | (_) | | | \__ \
#   |_| \_\___||___/\__\___/|_|  \___| |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#

function restore_file_to_partition() {
# Description: Restore partition from <infile> to <partmtd>
# Syntax: restore_file_to_partition <partname> <restore_stage_dir> <infile> <partname>
	local partname="$1"
	local restore_stage_dir="$2"
	local infile_name="$3"
	local partmtd="$4"
	
	cd "$restore_stage_dir"
	msg "- Restore: file $outfile to $partname at $partmtd ---"
	[ ! -f $infile_name ] && { msg " + $infile_name is missing" ; return 1 ; }
	
	msg_nonewline " + Checking md5 of $infile_name: "
	if [[ "$dry_run" == "yes" ]]; then
		md5sum -c $infile_name.md5sum && { msg "succeeded" ; msg_dry_run "flash_eraseall $partmtd && flashcp $infile_name $partmtd" ; } || { msg "failed" ; return 1 ; }
	else
		md5sum -c $infile_name.md5sum && { msg "succeeded" ; flash_eraseall $partmtd && flashcp $infile_name $partmtd && msg " + Restore succeeded" ; } || { msg "failed" ; return 1 ; }
	fi
}
                                  
function restore_t20_stock_parts() {
# Description: Restore stock partitions from partition images on T20 flash chip
	for partname in $t20_stock_restore_partname_list; do
		local infile_name=$(get_t20_stock_partimg $partname)
		local infile="$restore_dir/$infile_name"
		local partmtd=$(get_t20_stock_partmtd $partname)
		local restore_opt_value=$(get_t20_stock_restore_opt_value $partname)
		
		msg "- Restore: $partname from file $infile"
		if [[ "$restore_opt_value" == "yes" ]]; then
			msg " + t20_restore_$partname value is Yes"
			restore_file_to_partition $partname $infile $partmtd || { msg "Restore $infile to $partname partition failed" ; exit_init ; }
		else
			msg " + t20_restore_$partname value is No"
		fi
	done
}

function restore_t31_stock_parts() {
# Description: Restore stock partitions from partition images on T31 flash chip	
	for partname in $t31_stock_restore_partname_list; do
		local infile_name=$(get_t31_stock_partimg $partname)
		local infile="$restore_dir/$infile_name"
		local partmtd=$(get_t31_stock_partmtd $partname)
		local restore_opt_value=$(get_t31_stock_restore_opt_value $partname)
		
		msg "- Restore: $partname from file $infile"
		if [[ "$restore_opt_value" == "yes" ]]; then
			msg " + t31_restore_$partname value is Yes"
			restore_file_to_partition $partname $infile $partmtd || { msg "Restore $infile to $partname partition failed" ; exit_init ; }
		else
			msg " + t31_restore_$partname value is No"
		fi
	done
}

function restore_openipc_parts() {
# Description: Restore OpenIPC partitions from partition images
	for partname in $openipc_restore_partname_list; do
		local infile_name=$(get_openipc_partimg $partname)
		local infile="$restore_dir/$infile_name"
		local partmtd=$(get_openipc_partmtd $partname)
		local restore_opt_value=$(get_openipc_restore_opt_value $partname)
		
		msg "- Restore: $partname from file $infile"
		if [[ "$restore_opt_value" == "yes" ]]; then
			msg " + openipc_restore_$partname value is Yes"
			restore_file_to_partition $partname $infile $partmtd || { msg "Restore $infile to $partname partition failed" ; exit_init ; }
		else
			msg " + openipc_restore_$partname value is No"
		fi
	done
}

function do_restore_operation() {
# Description: Restore flash partitions using partition images
	[[ "$switch_fw" == "yes" ]] && { msg "Restore and Switch_fw operation are conflicted, please enable only one option at a time" ; exit_init ; }
	
	[[ ! "$current_fw_type" == "$restore_fw_type" ]] && { msg "restore_fw_type mismatches with current firmware type, aborting" ; exit_init ; }
	
	case "$current_fw_type" in
		"stock")
			restore_dir_name="$stock_restore_dir_name"
			;;
		"openipc")
			restore_dir_name="$openipc_restore_dir_name"
			;;
	esac

	restore_dir="$restore_dir_path/$restore_dir_name"
	[ ! -d $restore_dir ] && { msg "$restore_dir directory is missing" ; exit_init ; }
	
	cp -r $restore_dir /$restore_dir_name # Copy the restore directory to RAM in case of defective SD card
	
	/blink_led_red.sh &
	red_led_pid="$!"
	msg
	msg "---------- Begin of restore operation ----------"
	if [[ "$restore_fw_type" == "stock" ]] && [[ "$chip_family" = "t20" ]]; then
		msg "Restoring stock partitions for T20 camera"
		restore_t20_stock_parts
	elif [[ "$restore_fw_type" == "stock" ]] && [[ "$chip_family" = "t31" ]]; then
		msg "Restoring stock partitions for T31 camera"
		restore_t31_stock_parts
	elif [[ "$restore_fw_type" == "openipc" ]]; then
		msg "Restoring OpenIPC partitions for T20 camera"
		restore_openipc_parts
	fi
	kill $red_led_pid
	rm -r /$restore_dir_name
}
