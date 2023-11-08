#!/bin/sh
#
# Description: Miscellaneous functions
#

function gen_4digit_id() {
# Description: Return a random number in 1000-9999 range
	shuf -i 1000-9999 -n 1
}

function rollback_boot_partition() {
# Description: Check if written boot partition is valid. If not, rollback with the backup boot image
	msg
	msg "ATTENTION! ATTENTION! ATTENTION!"
	msg "ATTENTION! ATTENTION! ATTENTION!"
	msg "ATTENTION! ATTENTION! ATTENTION!"
	msg
	msg "It is very likely that your boot partition is corrupted"
	msg "Rolling back boot partition with previous profile boot image"
	msg
	
	for attempt in 1 2; do
		msg "- Rollback attempt $attempt:"
		msg_nonewline " + Rollback result: "
		write_partition "boot" /boot_backup.img $boot_partmtd && { msg "good :) You are safe now!" ; return 1 ; } || msg "bad"
	done
	
	msg "Rollback failed twice, sorry. Probably your flash chip is corrupted"
	return 1
}

function custom_script_matched_profile_check() {
# Description: Make sure the current profile is amatched profile and not switching profile, or switching to matched profile
	local matched_profile="$1"
	msg "- This script requires your camera to be on $match_profile profile to run"
	
	local run_flag="false"
	[[ "$switch_profile" == "yes" ]] && [[ "$next_profile" == "$matched_profile" ]] && run_flag="true"
	[[ ! "$switch_profile" == "yes" ]] && [[ "$current_profile" == "$matched_profile" ]] && run_flag="true"
	
	if [[ "$run_flag" == "true" ]]; then
		msg " + Camara is on $matched_profile, this script will start"
		msg
		return 0
	else
		msg " + Camara is not on $matched_profile, this script will be skipped"
		msg
		msg "- Skipping script"
		return 1
	fi
}
