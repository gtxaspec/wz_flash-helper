#!/bin/sh




function restore_t31_stock_parts() {
# Description: Restore stock partitions from partition images on T31 flash chip	
	for partname in $t31_stock_restore_partname_list; do
		local infile_name=$(get_t31_stock_partimg $partname)
		local infile="$restore_dir/$infile_name"
		local partmtd=$(get_t31_stock_partmtd $partname)
		local restore_opt_value=$(get_t31_stock_restore_opt_value $partname)
		
		msg "- Restore: $partname from file $infile"
		if [[ "$restore_opt_value" == "yes" ]]; then
			msg " + t31_restore_$partname value is Yes"
			restore_file_to_partition $partname $infile $partmtd || { msg "Restore $infile to $partname partition failed" ; exit_init ; }
		else
			msg " + t31_restore_$partname value is No"
		fi
	done
}
