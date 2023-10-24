#!/bin/sh




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
