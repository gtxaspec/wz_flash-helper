#!/bin/sh




function switch_fw_stock_to_openipc() {
# Description: Switch from stock to OpenIPC firmware by flashing all partitions OpenIPC partition images

	msg " - Making sure that all needed partition images present and are valid"
	cd $openipc_restore_dir_path
	for partname in $openipc_switch_fw_write_partname_list; do # Do md5 check for all partitions first to make sure they are all valid before flashing each partition
		local infile_name=$(get_openipc_partimg $partname)
		msg_nonewline " + Verifying $infile_name... "
		md5sum -c $infile_name.md5sum && msg "ok" || { msg "failed" ; return 1 ; }
	done
	
	for partname in $openipc_switch_fw_write_partname_list; do
		local infile_name=$(get_openipc_partimg $partname)
		local infile="$openipc_restore_dir_path/$infile_name"
		local partmtd=$(get_openipc_partmtd $partname)
		restore_file_to_partition $partname $infile $partmtd || { msg "Failed to write $partname partition image, aborting firmware switch" ; return 1 ; }
	done
	
	for partname in $openipc_switch_fw_erase_partname_list; do
		local partmtd=$(get_openipc_partmtd $partname)
		erase_partition $partname $partmtd || { msg "Failed to erase $partname, aborting firmware switch" ; return 1 ; }
	done
}

switch_fw_stock_to_openipc || return 1
