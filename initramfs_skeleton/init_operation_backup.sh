#!/bin/sh
#
#  ____             _                                             _   _             
# | __ )  __ _  ___| | ___   _ _ __     ___  _ __   ___ _ __ __ _| |_(_) ___  _ __  
# |  _ \ / _` |/ __| |/ / | | | '_ \   / _ \| '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \ 
# | |_) | (_| | (__|   <| |_| | |_) | | (_) | |_) |  __/ | | (_| | |_| | (_) | | | |
# |____/ \__,_|\___|_|\_\\__,_| .__/   \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|
#                             |_|           |_|                                     



source /init_functions_io.sh


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
	
	backup_partition_to_file $partname $partmtd $outfile || { msg "Backup $partname partition to $outfile failed" ; exit_init ; }
}

function backup_t20_stock_parts() {
# Description: Create partition images of all stock partitions on T20 flash chip
	for partname in $t20_stock_backup_partname_list; do
		local partmtd=$(get_t20_stock_partmtd $partname)
		local outfile_name=$(get_t20_stock_partimg $partname)
		local outfile="$stock_backup_dir_path/$outfile_name"
		
		backup_partition_to_file $partname $partmtd $outfile || { msg "Backup $partname partition to $outfile failed" ; break ; exit_init ; }
	done
}

function backup_t20_stock_config() {
# Description: Create .tar.gz archive for config partition files on T20 flash chip
	local partname="config"
	local partmtdblock="$config_t20_stock_partmtdblock"
	local outfile="$stock_backup_dir_path/t20_stock_$partname.tar.gz"
	
	backup_stock_config_part_files_to_archive $partname $partmtdblock $outfile
}

function backup_t20_stock_para() {
# Description: Create .tar.gz archive for para partition files on T20 flash chip
	local partname="para"
	local partmtdblock="$para_t20_stock_partmtdblock"
	local outfile="$stock_backup_dir_path/t20_stock_$partname.tar.gz"
	
	backup_stock_config_part_files_to_archive $partname $partmtdblock $outfile
}

function backup_t31_stock_parts() {
# Description: Create partition images of all stock partitions on T31 flash chip
	
	for partname in $t31_stock_backup_partname_list; do
		local partmtd=$(get_t31_stock_partmtd $partname)
		local outfile_name=$(get_t31_stock_partimg $partname)
		local outfile="$stock_backup_dir_path/$outfile_name"
		
		backup_partition_to_file $partname $partmtd $outfile || { msg "Backup $partname partition to $outfile failed" ; break ; exit_init ; }
	done
}

function backup_t31_stock_config() {
# Description: Create .tar.gz archive for config partition files on T31 flash chip
	local partname="cfg"
	local partmtdblock="$cfg_t31_stock_partmtdblock"
	local outfile="$stock_backup_dir_path/t31_stock_$partname.tar.gz"
	
	backup_stock_config_part_files_to_archive $partname $partmtdblock $outfile
}

function backup_openipc_parts() {
# Description: Create partition images of all OpenIPC partitions on T31 flash chip
	msg "Backing up OpenIPC partitions"
	
	for partname in $openipc_backup_partname_list; do
		local partmtd=$(get_openipc_partmtd $partname)
		local outfile_name=$(get_openipc_partimg $partname)
		local outfile="$openipc_backup_dir_path/$outfile_name"
		
		backup_partition_to_file $partname $partmtd $outfile || { msg "Backup $partname partition to $outfile failed" ; break ; exit_init ; }
	done
}

backup_operation() {
	/blinkled_led_blue.sh &
	blue_led_pid="$!"
	msg
	msg "---------- Begin of backup operation ----------"
	if [[ "$current_fw_type" == "stock" ]] && [[ "$chip_family" = "t20" ]]; then
		msg "Backing up T20 stock partitions"
		mkdir -p $stock_backup_dir_path
		backup_full_flash
		backup_t20_stock_parts
		backup_t20_stock_config
		backup_t20_stock_para
		
	elif [[ "$current_fw_type" == "stock" ]] && [[ "$chip_family" = "t31" ]]; then
		mkdir -p $stock_backup_dir_path
		msg "Backing up T31 stock partitions"

		backup_full_flash
		backup_t31_stock_parts
		backup_t31_stock_config
		
	elif [[ "$current_fw_type" == "openipc" ]]; then
		msg "Backing up OpenIPC partitions"
		mkdir -p $openipc_backup_dir_path
		backup_full_flash
		backup_openipc_parts
		
	fi
	kill $red_led_pid
}

backup_operation
