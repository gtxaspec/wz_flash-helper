#!/bin/sh




function backup_openipc_parts() {
# Description: Create partition images of all OpenIPC partitions on T31 flash chip
	msg "Backing up OpenIPC partitions"
	
	for partname in $openipc_backup_partname_list; do
		local partmtd=$(get_openipc_partmtd $partname)
		local outfile_name=$(get_openipc_partimg $partname)
		local outfile="$openipc_backup_dir_path/$outfile_name"
		
		backup_partition_to_file $partname $partmtd $outfile || { msg "Backup $partname partition to $outfile failed" ; break ; return 1 ; }
	done
}

backup_openipc_parts || return 1
