#!/bin/sh
#
# Description: Extract archive file to a chosen writable partition on a matched profile
#



# ---------- Begin of user customization ----------

## Absolute path of the archive file on SD card, must start with /sdcard
archive_file=""

## Name of the partition that the archive will be extracted to, defined on the profile
partition_name=""

## Name of the profile that script will only run on
matched_profile=""


# ---------- End of user customization ----------










##### DO NOT MODIFY THE BELOW CODE #####

function extract_archive_file_to_partition() {
	local partname="$partition_name"
	local infile="$archive_file"
	
	if [[ "$switch_profile" == "yes" ]]; then
		local partmtdblock=$(get_np_partmtdblock $partname)
		local partfstype=$(get_np_partfstype $partname)
	else
		local partmtdblock=$(get_cp_partmtdblock $partname)
		local partfstype=$(get_cp_partfstype $partname)
	fi
		
	extract_archive_to_partition $partname $infile $partmtdblock $partfstype || return 1
}

custom_script_matched_profile_check $matched_profile || return 0
extract_archive_file_to_partition || return 1
