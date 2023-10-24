#!/bin/sh




function backup_t31_stock_parts() {
# Description: Create partition images of all stock partitions on T31 flash chip
	
	for partname in $t31_stock_backup_partname_list; do
		local partmtd=$(get_t31_stock_partmtd $partname)
		local outfile_name=$(get_t31_stock_partimg $partname)
		local outfile="$stock_backup_dir_path/$outfile_name"
		
		backup_partition_to_file $partname $partmtd $outfile || { msg "Backup $partname partition to $outfile failed" ; break ; return 1 ; }
	done
}

function backup_t31_stock_config() {
# Description: Create .tar.gz archive for config partition files on T31 flash chip
	local partname="cfg"
	local partmtdblock="$cfg_t31_stock_partmtdblock"
	local outfile="$stock_backup_dir_path/t31_stock_$partname.tar.gz"
	
	backup_stock_config_part_files_to_archive $partname $partmtdblock $outfile
}

backup_t31_stock_parts || return 1
backup_t31_stock_config || return 1
