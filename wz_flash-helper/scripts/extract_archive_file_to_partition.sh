#!/bin/sh
#
# Description: Extract archive file to a chosen writable partition on a matched firmware
#



# ---------- Begin of user customization ----------

## Absolute path of the archive file on SD card, must start with /sdcard
archive_file=""

## Name of the partition that the archive will be extracted to, defined on the firmware
partition_name=""

## Name of the firmware that the script will only run on
matched_firmware=""

# ---------- End of user customization ----------










##### DO NOT MODIFY THE BELOW CODE #####

function extract_archive_file_to_partition() {
	local partname="$partition_name"
	local infile="$archive_file"

	if [[ "$switch_firmware" == "yes" ]]; then
		local partmtdblock=$(get_nf_partmtdblock $partname)
		local partfstype=$(get_nf_partfstype $partname)
	else
		local partmtdblock=$(get_cf_partmtdblock $partname)
		local partfstype=$(get_cf_partfstype $partname)
	fi

	extract_archive_to_partition $partname $infile $partmtdblock $partfstype || return 1
}

custom_script_matched_firmware_check $matched_firmware || return 0
extract_archive_file_to_partition || return 1
