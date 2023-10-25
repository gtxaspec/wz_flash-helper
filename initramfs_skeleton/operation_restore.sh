#!/bin/sh
#
#  ____           _                                              _   _             
# |  _ \ ___  ___| |_ ___  _ __ ___    ___  _ __   ___ _ __ __ _| |_(_) ___  _ __  
# | |_) / _ \/ __| __/ _ \| '__/ _ \  / _ \| '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \ 
# |  _ <  __/\__ \ || (_) | | |  __/ | (_) | |_) |  __/ | | (_| | |_| | (_) | | | |
# |_| \_\___||___/\__\___/|_|  \___|  \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|
#                                          |_|                                     



function restore_operation() {

	[[ "$switch_fw" == "yes" ]] && { msg "Restore and Switch_fw operations are conflicted, please enable only one option at a time" ; return 1 ; }
	
	[[ ! "$current_fw" == "$restore_fw_type" ]] && { msg "restore_fw_type mismatches with current firmware type, aborting" ; return 1 ; }
	
	case "$current_fw" in
		"stock")
			local restore_dir="$stock_restore_dir_path"
			;;
		"openipc")
			local restore_dir="$openipc_restore_dir_path"
			;;
	esac

	[ ! -d $restore_dir ] && { msg "$restore_dir directory is missing" ; return 1 ; }
	
	/bg_blink_led_red.sh &
	local red_led_pid="$!"
	msg
	msg "---------- Begin of restore operation ----------"
	if [[ "$restore_fw_type" == "stock" ]] && [[ "$chip_family" = "t20" ]]; then
		msg "Restoring stock partitions for T20 camera"
		source /suboperation_restore_t20.sh || return 1
		
	elif [[ "$restore_fw_type" == "stock" ]] && [[ "$chip_family" = "t31" ]]; then
		msg "Restoring stock partitions for T31 camera"
		source /suboperation_restore_t31.sh || return 1
		
	elif [[ "$restore_fw_type" == "openipc" ]]; then
		msg "Restoring OpenIPC partitions for T20 camera"
		source /suboperation_restore_openipc.sh || return 1
		
	fi
	kill $red_led_pid
	msg
}


restore_operation && msg "Restore operation succeeded" || return 1
