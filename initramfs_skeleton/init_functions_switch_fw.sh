#!/bin/sh
#
#    ____          _ _       _        __             __                  _   _                 
#   / ___|_      _(_) |_ ___| |__    / _|_      __  / _|_   _ _ __   ___| |_(_) ___  _ __  ___ 
#   \___ \ \ /\ / / | __/ __| '_ \  | |_\ \ /\ / / | |_| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#    ___) \ V  V /| | || (__| | | | |  _|\ V  V /  |  _| |_| | | | | (__| |_| | (_) | | | \__ \
#   |____/ \_/\_/ |_|\__\___|_| |_| |_|   \_/\_/   |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#
                                                                                            
function switch_fw_stock_to_openipc() {
# Description: Switch from stock to OpenIPC firmware by flashing all partitions OpenIPC partition images
	cp -r $stock_switch_fw_dir_path /switch_fw_stock_to_openipc
	cd /switch_fw_stock_to_openipc
	
	for partname in $openipc_backup_partname_list; do # Do md5 check for all partitions first to make sure they are all valid before flashing each partition
		md5sum -c $partname.md5sum || { msg "Failed to verify $partname partition image, aborting firmware switch" ; return 1 ; }
	done
	
	for partname in $openipc_backup_partname_list; do
		local infile_name=$(get_openipc_partimg $partname)
		local infile="/switch_fw_stock_to_openipc/$infile_name"
		local partmtd=$(get_openipc_partmtd $partname)
		restore_file_to_partition $partname $infile $partmtd || { msg "Failed to write $partname partition image, aborting firmware switch" ; return 1 ; }
	done
	rm -r switch_fw_stock_to_openipc
}

function switch_fw_openipc_to_t20_stock() {
# Description: Switch from OpenIPC to stock firmware on T20 by flashing all partitions stock partition images
	cp -r $openipc_switch_fw_dir_path /switch_fw_openipc_to_t20_stock
	cd /switch_fw_openipc_to_t20_stock
	
	for partname in $t20_stock_backup_partname_list; do # Do md5 check for all partitions first to make sure they are all valid before flashing each partition
		md5sum -c $partname.md5sum || { msg "Failed to verify $partname partition image, aborting firmware switch" ; return 1 ; }
	done
	
	for partname in $t20_stock_backup_partname_list; do
		local infile_name=$(get_t20_stock_partimg $partname)
		local infile="/switch_fw_openipc_to_t20_stock/$infile_name"
		local partmtd=$(get_t20_stock_partmtd $partname)
		restore_file_to_partition $partname $infile $partmtd || { msg "Failed to write $partname partition image, aborting firmware switch" ; return 1 ; }
	done
	rm -r /switch_fw_openipc_to_t20_stock
}

function switch_fw_openipc_to_t31_stock() {
# Description: Switch from OpenIPC to stock firmware on T31 by flashing all partitions stock partition images
	cp -r $openipc_switch_fw_dir_path /switch_fw_openipc_to_t31_stock
	cd /switch_fw_openipc_to_t31_stock
	
	for partname in $t31_stock_backup_partname_list; do # Do md5 check for all partitions first to make sure they are all valid before flashing each partition
		md5sum -c $partname.md5sum || { msg "Failed to verify $partname partition image, aborting firmware switch" ; return 1 ; }
	done
	
	for partname in $t31_stock_backup_partname_list; do
		local infile_name=$(get_t31_stock_partimg $partname)
		local infile="/switch_fw_openipc_to_t31_stock/$infile_name"
		local partmtd=$(get_t31_stock_partmtd $partname)
		restore_file_to_partition $partname $infile $partmtd || { msg "Failed to write $partname partition image, aborting firmware switch" ; return 1 ; }
	done
	rm -r /switch_fw_openipc_to_t31_stock
}

function erase_partition() {
# Description: Erase a partition using flash_eraseall
# Syntax: <partname> <partmtd>
	local partname="$1"
	local partmtd="$2"

	msg_nonewline "- Erase: $partname at $partmtd ---"
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "flash_eraseall $partmtd" && msg "succeeded"
	else
		flash_eraseall $partmtd && msg "succeeded" || { msg "failed" ; return 1 ; }
	fi
}

function do_switch_fw_operation() {
# Description: Switch firmware by flashing all needed partitions
	[[ "$restore_partitions" == "yes" ]] && { msg "Restore and Switch_fw operation are conflicted, please enable only one option at a time" ; exit_init ; }

	if [[ "$current_fw_type" == "$switch_fw_to" ]]; then
		{ msg "switch_fw_to value is same as current firmware type, aborting firmware switch" ; exit_init ; }
	fi
	
	/blink_led_red_and_blue.sh &
	red_and_blue_leds_pid="$!"
	if [[ "$current_fw_type" == "stock" ]] && [[ "$switch_fw_to" == "openipc" ]]; then
		msg "Switching from stock firmware to OpenIPC"
		switch_fw_stock_to_openipc
	
	elif [[ "$current_fw_type" == "stock" ]] && [[ "$switch_fw_to" == "stock" ]] && [[ "$chip_family" == "t20" ]]; then
		msg "Switching from OpenIPC firmware to T20 stock"
		switch_fw_openipc_to_t20_stock
	
	elif [[ "$current_fw_type" == "stock" ]] && [[ "$switch_fw_to" == "stock" ]] && [[ "$chip_family" == "t31" ]]; then
		msg "Switching from OpenIPC firmware to T31 stock"
		switch_fw_openipc_to_t31_stock
	
	fi
	kill $red_and_blue_leds_pid
}

