#!/bin/sh




function switch_fw_openipc_to_t20_stock() {
# Description: Switch from OpenIPC to stock firmware on T20 by flashing all partitions stock partition images	
	
	msg " - Making sure that all needed partition images present and are valid"
	cd $stock_restore_dir_path
	for partname in $t20_stock_backup_partname_list; do # Do md5 check for all partitions first to make sure they are all valid before flashing each partition
		local infile_name=$(get_t20_stock_partimg $partname)
		msg_nonewline " + Verifying $infile_name... "
		md5sum -c $infile_name.md5sum && msg "ok" || { msg "failed" ; return 1 ; }
	done
	
	for partname in $t20_stock_backup_partname_list; do
		local infile_name=$(get_t20_stock_partimg $partname)
		local infile="$stock_restore_dir_path/$infile_name"
		local partmtd=$(get_t20_stock_partmtd $partname)
		restore_file_to_partition $partname $infile $partmtd || { msg "Failed to write $partname partition image, aborting firmware switch" ; return 1 ; }
	done
}

switch_fw_openipc_to_t20_stock || return 1
