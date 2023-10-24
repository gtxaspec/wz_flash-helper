#!/bin/sh




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

switch_fw_stock_to_openipc || return 1
