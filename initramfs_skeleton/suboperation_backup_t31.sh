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
	for partname_config in $t31_stock_backup_partname_with_contents_list; do
		local partname="$partname_config"
		local partmtdblock="$(get_t31_stock_partmtdblock $partname_config)"
		local outfile="$stock_backup_dir_path/t31_stock_$partname.tar.gz"
		
		archive_partition_files $partname $partmtdblock $outfile
	done
}

backup_t31_stock_parts || return 1
backup_t31_stock_config || return 1
