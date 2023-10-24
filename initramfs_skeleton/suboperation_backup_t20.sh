#!/bin/sh




function backup_t20_stock_parts() {
# Description: Create partition images of all stock partitions on T20 flash chip
	for partname in $t20_stock_backup_partname_list; do
		local partmtd=$(get_t20_stock_partmtd $partname)
		local outfile_name=$(get_t20_stock_partimg $partname)
		local outfile="$stock_backup_dir_path/$outfile_name"
		
		backup_partition_to_file $partname $partmtd $outfile || { msg "Backup $partname partition to $outfile failed" ; break ; return 1 ; }
	done
}

function backup_t20_stock_config() {
# Description: Create .tar.gz archive for config partition files on T20 flash chip
	local partname="config"
	local partmtdblock="$config_t20_stock_partmtdblock"
	local outfile="$stock_backup_dir_path/t20_stock_$partname.tar.gz"
	
	backup_stock_config_part_files_to_archive $partname $partmtdblock $outfile || return 1
}

function backup_t20_stock_para() {
# Description: Create .tar.gz archive for para partition files on T20 flash chip
	local partname="para"
	local partmtdblock="$para_t20_stock_partmtdblock"
	local outfile="$stock_backup_dir_path/t20_stock_$partname.tar.gz"
	
	backup_stock_config_part_files_to_archive $partname $partmtdblock $outfile || return 1
}

backup_t20_stock_parts || return 1
backup_t20_stock_config || return 1
backup_t20_stock_para || return 1
