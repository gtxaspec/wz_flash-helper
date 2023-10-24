#!/bin/sh
#
#  ____             _                                             _   _             
# | __ )  __ _  ___| | ___   _ _ __     ___  _ __   ___ _ __ __ _| |_(_) ___  _ __  
# |  _ \ / _` |/ __| |/ / | | | '_ \   / _ \| '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \ 
# | |_) | (_| | (__|   <| |_| | |_) | | (_) | |_) |  __/ | | (_| | |_| | (_) | | | |
# |____/ \__,_|\___|_|\_\\__,_| .__/   \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|
#                             |_|           |_|                                     



case "$current_fw" in
	"t20")
		source /init_operation_backup_t20.sh ;;
	"t30")
		source /init_operation_backup_t31.sh ;;
	"openipc")
		source /init_operation_backup_openipc.sh ;;
esac


function backup_full_flash() {
# Description: Backup the whole flash to a file
	if [[ "$current_fw_type" == "stock" ]] && [[ "$chip_family" == "t20" ]]; then
		full_flash_backup_file=$stock_backup_dir_path/$t20_stock_full_flash_filename
	
	elif [[ "$current_fw_type" == "stock" ]] && [[ "$chip_family" == "t31" ]]; then
		full_flash_backup_file=$stock_backup_dir_path/$t31_stock_full_flash_filename
	
	elif [[ "$current_fw_type" == "openipc" ]]; then
		full_flash_backup_file=$openipc_backup_dir_path/$openipc_full_flash_filename
	
	fi
	
	local partname="entire_flash"
	local partmtd="$concat_partmtd"
	local outfile="$full_flash_backup_file"
	
	backup_partition_to_file $partname $partmtd $outfile || { msg "Backup $partname partition to $outfile failed" ; return 1 ; }
}



function backup_operation() {
	/blinkled_led_blue.sh &
	blue_led_pid="$!"
	msg
	msg "---------- Begin of backup operation ----------"
	if [[ "$current_fw_type" == "stock" ]] && [[ "$chip_family" = "t20" ]]; then
		msg "Backing up T20 stock partitions"
		mkdir -p $stock_backup_dir_path
		backup_full_flash || return 1
		backup_t20_stock_parts || return 1
		backup_t20_stock_config || return 1
		backup_t20_stock_para || return 1
		
	elif [[ "$current_fw_type" == "stock" ]] && [[ "$chip_family" = "t31" ]]; then
		mkdir -p $stock_backup_dir_path
		msg "Backing up T31 stock partitions"

		backup_full_flash || return 1
		backup_t31_stock_parts || return 1
		backup_t31_stock_config || return 1
		
	elif [[ "$current_fw_type" == "openipc" ]]; then
		msg "Backing up OpenIPC partitions"
		mkdir -p $openipc_backup_dir_path
		backup_full_flash || return 1
		backup_openipc_parts || return 1
		
	fi
	kill $red_led_pid
}

backup_operation
