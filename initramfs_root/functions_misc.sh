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
	msg_color_bold red "ATTENTION! ATTENTION! ATTENTION!"
	msg_color_bold red "ATTENTION! ATTENTION! ATTENTION!"
	msg_color_bold red "ATTENTION! ATTENTION! ATTENTION!"
	msg
	msg "It is very likely that your boot partition is corrupted"
	msg "Rolling back boot partition with previous profile boot image"
	msg
	
	for attempt in 1 2; do
		msg "- Rollback attempt $attempt:"
		msg_nonewline "   Rollback result: "
		write_partition "boot" /boot_backup.img $boot_partmtd && { msg_color green "good :) You are safe now!" ; return 1 ; } || msg_color red "bad"
	done
	
	msg_color_bold red "Rollback failed twice, sorry. Probably your flash chip is corrupted"
	return 1
}

function custom_script_matched_profile_check() {
# Description: Make sure the current profile is amatched profile and not switching profile, or switching to matched profile
	local matched_profile="$1"
	msg_color_bold_nonewline white "This script requires the running profile to be "
	msg_color_nonewline cyan "$matched_profile "
	msg_color_bold "to run"
	
	[[ ! "$switch_profile" == "yes" ]] && local running_profile=$current_profile	
	[[ "$switch_profile" == "yes" ]] && local running_profile=$next_profile

	msg_nonewline "   The running profile is: "
	msg_color_nonewline cyan "$running_profile"
	msg_nonewline ", "
	if [[ "$running_profile" == "$matched_profile" ]]; then
		msg_color green "running script now!"
		msg
	else
		msg_color lightbrown "skipping script"
		return 1
	fi
}
