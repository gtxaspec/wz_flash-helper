#!/bin/sh
#
# Description: Extract archive file to a chosen writable partition on a matched profile
#



# ---------- Begin of user customization ----------

## Absolute path of the archive file on SD card, must start with /sdcard
archive_file=""

## Name of the partition that the archive will be extracted to, defined on the profile
partition_name=""

## Name of the profile as the condition for the script to run
matched_profile=""


# ---------- End of user customization ----------










##### DO NOT MODIFY THE BELOW CODE #####

function extract_archive_to_partition() {
	custom_script_matched_profile_check || return 0

	local partname="$partition_name"
	local infile="$archive_file"
	
	if [[ "$switch_profile" == "yes" ]]; then
		local partnum=$(get_np_partnum $partname)
		local partfstype=$(get_np_partfstype $partname)
	else
		local partnum=$(get_cp_partnum $partname)
		local partfstype=$(get_cp_partfstype $partname)
	fi
		
	extract_archive_to_partition $partname $infile $partmtdblock $partfstype || return 1
}

extract_archive_to_partition || return 1
