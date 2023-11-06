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
function pre_script_check() {
# Description: Make sure current profile is matched_profile and not switching profile, or switching to matched_profile
	msg "- Checking conditions to run this script"
	msg " + current_profile: $current_profile, next_profile: $next_profile, switch_profile: $switch_profile, matched_profile: $matched_profile"
	
	[[ "$switch_profile" == "yes" ]] && [[ "$next_profile" == "$matched_profile" ]] && return 0
	[[ ! "$switch_profile" == "yes" ]] && [[ "$current_profile" == "$matched_profile" ]] && return 0

	msg " + Conditions for this script to run are not met. For it to run, the camera must either:"
	msg "  . is on $matched_profile and not switching profile, or"
	msg "  . already switched to $matched_profile profile"
	
	return 1
}

function extract_archive_to_partition() {
	pre_script_check && msg " + Conditions to run script are met, starting script now" || { msg ; msg "- Exitting script" ; return 0 ; }

	local partname="$partition_name"
	local infile="$archive_file"
	
	case $switch_profile in
		"yes")
			local partmtdblock=$(get_next_profile_partmtdblock $partname)
			local partfstype=$(get_next_profile_partfstype $partname)
			;;
		*)
			local partmtdblock=$(get_current_profile_partmtdblock $partname)
			local partfstype=$(get_current_profile_partfstype $partname)
			;;
	esac
	
	msg_nonewline " - Extracting... "
	extract_archive_to_partition $partname $infile $partmtdblock $partfstype && msg "ok" || { msg "failed" ; return 1 ; }
}

extract_archive_to_partition || return 1
