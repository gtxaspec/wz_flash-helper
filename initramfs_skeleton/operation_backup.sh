#!/bin/sh
#
#  ____             _                                             _   _             
# | __ )  __ _  ___| | ___   _ _ __     ___  _ __   ___ _ __ __ _| |_(_) ___  _ __  
# |  _ \ / _` |/ __| |/ / | | | '_ \   / _ \| '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \ 
# | |_) | (_| | (__|   <| |_| | |_) | | (_) | |_) |  __/ | | (_| | |_| | (_) | | | |
# |____/ \__,_|\___|_|\_\\__,_| .__/   \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|
#                             |_|           |_|                                     



function backup_full_flash() {
# Description: Backup the entire flash to a file
	local partname="entire_flash"
	local partmtd="$concat_partmtd"
	local outfile="$full_flash_backup_file"
	
	backup_partition_to_file $partname $partmtd $outfile || { msg "Backup $partname partition to $outfile failed" ; return 1 ; }
}



function backup_operation() {
# Description: Create partition images of all partitions and the entire flash. If current firmware is stock, create extra archives from config partitions
	if [[ "$current_fw" == "stock" ]] && [[ "$chip_family" == "t20" ]]; then
		local full_flash_backup_file="$stock_backup_dir_path/$t20_stock_backup_full_flash_filename"
	
	elif [[ "$current_fw" == "stock" ]] && [[ "$chip_family" == "t31" ]]; then
		local full_flash_backup_file="$stock_backup_dir_path/$t31_stock_backup_full_flash_filename"
	
	elif [[ "$current_fw" == "openipc" ]]; then
		local full_flash_backup_file="$openipc_backup_dir_path/$openipc_backup_full_flash_filename"
	
	fi

	/bg_blink_led_blue.sh &
	local blue_led_pid="$!"
	msg
	msg "---------- Begin of backup operation ----------"
	if [[ "$current_fw" == "stock" ]] && [[ "$chip_family" = "t20" ]]; then
		msg "Backing up T20 stock partitions"
		
		mkdir -p $stock_backup_dir_path
		backup_full_flash "$full_flash_backup_file" || return 1
		source /suboperation_backup_t20.sh || return 1
		
	elif [[ "$current_fw" == "stock" ]] && [[ "$chip_family" = "t31" ]]; then
		msg "Backing up T31 stock partitions"
		
		mkdir -p $stock_backup_dir_path
		backup_full_flash "$full_flash_backup_file" || return 1
		source /suboperation_backup_t31.sh || return 1
		
	elif [[ "$current_fw" == "openipc" ]]; then
		msg "Backing up OpenIPC partitions"
		
		mkdir -p $openipc_backup_dir_path
		backup_full_flash "$full_flash_backup_file" || return 1
		source /suboperation_backup_openipc.sh || return 1
		
	fi
	kill $blue_led_pid
	msg
}

backup_operation && msg "Backup operation succeeded" || return 1
