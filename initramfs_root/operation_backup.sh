#!/bin/sh
#
#  ____             _                                             _   _             
# | __ )  __ _  ___| | ___   _ _ __     ___  _ __   ___ _ __ __ _| |_(_) ___  _ __  
# |  _ \ / _` |/ __| |/ / | | | '_ \   / _ \| '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \ 
# | |_) | (_| | (__|   <| |_| | |_) | | (_) | |_) |  __/ | | (_| | |_| | (_) | | | |
# |____/ \__,_|\___|_|\_\\__,_| .__/   \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|
#                             |_|           |_|                                     



function ob_backup_entire_flash() {
# Description: Dump the entire flash to a file
	local partname="entire_flash"
	local partmtd="$all_partmtd"
	local outfile="$cp_backup_path/$cp_backup_allparts_filename"
	
	read_partition $partname $partmtd $outfile || { msg "Backup $partname partition to $outfile failed" ; return 1 ; }
}

function ob_backup_partitions() {
# Description: Create images for all partitions of the current profile
	for partname in $cp_all_partname_list; do
		local partmtd=$(get_cp_partmtd $partname)
		local outfile_name=$(get_cp_partimg $partname)
		local outfile="$cp_backup_path/$outfile_name"
		
		read_partition $partname $partmtd $outfile || { msg "Backup $partname partition to $outfile failed" ; return 1 ; }
	done
}

function ob_archive_partitions() {
# Description: Create .tar.gz archive for partition files on the current profile
	for partname_archive in $cp_archive_partname_list; do
		local partname="$partname_archive"
		local partmtdblock="$(get_cp_partmtdblock $partname_archive)"
		local partfstype="$(get_cp_partfstype $partname_archive)"
		local outfile="$cp_backup_path/${current_profile}_${chip_group}_${partname}.tar.gz"
		
		create_archive_from_partition $partname $partmtdblock $partfstype $outfile
	done
}

function operation_backup() {
# Description: Create partition images of the entire flash, all partitions, and create extra archives from config partitions
	mkdir -p $cp_backup_path || { msg "Failed to create backup directory at $cp_backup_path" ; return 1 ; }
	
	backup_id=$(gen_4digit_id)
	local backup_id_gen_attempt=1
	
	while [ -d $cp_backup_path/$backup_id ]; do
		backup_id=$(gen_4digit_id)
		((backup_id_gen_attempt++))
		[[ "$backup_id_gen_attempt" -gt 10000 ]] && { msg "All 10000 attempts to generate backup ID have failed, your backup directory is probably full" ; return 1 ; }
	done
	
	cp_backup_path="$cp_backup_path/$backup_id"
	mkdir -p $cp_backup_path
	
	/bg_blink_led_blue.sh &
	local blue_led_pid="$!"
	msg
	msg "---------- Begin of backup operation ----------"
	msg "Backup ID: $backup_id"
	msg "Backup destination: $cp_backup_path"
	echo "$backup_id" > $cp_backup_path/ID.txt
	msg
	ob_backup_entire_flash || return 1
	ob_backup_partitions || return 1
	ob_archive_partitions || return 1
	msg
	if [[ ! "$cp_backup_secondary_path" == "" ]] && [[ ! "$dry_run" == "yes" ]]; then
		msg "- This profile has secondary backup directory at $cp_backup_secondary_path"
		msg_nonewline " + Creating a copy from primary backup... "
		
		if [ -d $cp_backup_secondary_path/$backup_id ]; then
			msg "failed"
			msg " + Backup with ID $backup_id exists on secondary backup directory, it will not be overwritten, skipping"
		else
			mkdir -p $cp_backup_secondary_path	
			cp -r $cp_backup_path $cp_backup_secondary_path && msg "ok" || { msg "failed" ; return 1 ; }
		fi	
	fi
	sync
	msg
	msg "----------- End of backup operation -----------"
	msg
	kill $blue_led_pid
	/bg_turn_off_leds.sh
}

operation_backup || return 1
