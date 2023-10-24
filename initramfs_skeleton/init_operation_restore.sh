#!/bin/sh
#
#  ____           _                                              _   _             
# |  _ \ ___  ___| |_ ___  _ __ ___    ___  _ __   ___ _ __ __ _| |_(_) ___  _ __  
# | |_) / _ \/ __| __/ _ \| '__/ _ \  / _ \| '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \ 
# |  _ <  __/\__ \ || (_) | | |  __/ | (_) | |_) |  __/ | | (_| | |_| | (_) | | | |
# |_| \_\___||___/\__\___/|_|  \___|  \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|
#                                          |_|                                     


case "$current_fw" in
	"t20")
		source /init_operation_restore_t20.sh ;;
	"t30")
		source /init_operation_restore_t31.sh ;;
	"openipc")
		source /init_operation_restore_openipc.sh ;;
esac


function restore_operation() {

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

restore_operation
