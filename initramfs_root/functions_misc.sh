#!/bin/sh
#
# Miscellaneous functions


function gen_4digit_id() {
# Description: Return a random number in 1000-9999 range
	shuf -i 1000-9999 -n 1
}

function play_audio() {
# Description: Play audio to let the user keep track of the progress, useful when they don't have a serial connection
	! lsmod | grep -q audio && return 0
	[[ ! "$enable_audio" == "yes" ]] && return 0

	local audio_file="$1"
	local numberic='^[0-9]+$'

	if [[ ! "$audio_volume" =~ $numberic ]] || [ -z "$audio_volume" ] || [ "$audio_volume" -lt 0 ] || [ "$audio_volume" -gt 100 ]; then
		local audio_volume="50" # If the audio value is invalid, set it to 50
	fi
	audioplay $audio_file $audio_volume
}

function drop_a_shell() {
# Description: Drop initramfs shell
	echo > /dev/console
	echo "Dropping a shell, the init script will be resumed after you exit this shell" > /dev/console
	echo "If you want to force a reboot, please run: reboot -f" > /dev/console
	echo > /dev/console

	exec 0< /dev/console
	exec 1> /dev/console
	exec 2> /dev/console

	/bin/sh -l

	exec > /tmp/initramfs.log 2>&1 # Redirect output back to the log file
	exec 0< /dev/null # Stop the user from typing on the serial terminal
	echo > /dev/console

	echo "Continuing init" > /dev/console
	sleep 1
}

function unpad_partimg() {
# Remove padding blocks from partition image <infile> to create a new partition image <outfile>
# Syntax: unpad_infile <infile> <blocksize> <outfile>
	local infile="$1"
	local blocksize="$2"
	local outfile="$3"

	[ ! -f $infile ] && { echo "Partition image $infile is missing" ; return 1 ; }

	local infile_size=$(du -b $infile | cut -f -1)
	local infile_totalblocks=$(( $infile_size/$blocksize ))
	local infile_totalblocks_minusone=$(( $infile_totalblocks - 1 ))
	local padding_block=$(dd if=/dev/zero bs=$blocksize count=1 status=none | tr '\0' '\377')

	local block_contents=""
	local padding_blocks_total="0"

	echo "Counting padded blocks..."
	for block in $(seq $infile_totalblocks_minusone -1 0); do
		block_contents=$(dd if=$infile bs=$blocksize count=1 skip=$block status=none | tr -d '\000')
		if [[ "$block_contents" == "$padding_block" ]]; then
			padding_blocks_total=$(( $padding_blocks_total + 1 ))
			# echo "Block $block is padded"
		else
			break
		fi
	done

	echo "Creating unpadded partition image..."
	dd if=$infile of=$outfile bs=$blocksize count=$(( $infile_totalblocks - $padding_blocks_total )) status=none || return 1

	echo "Data block counts: $(( $infile_totalblocks - $padding_blocks_total ))"
	echo "Padded block counts: $padding_blocks_total"
}

function rollback_boot_partition() {
# Description: Check if written boot partition is valid. If not, rollback with the backup boot image
	msg
	msg_color_bold red "ATTENTION! ATTENTION! ATTENTION!"
	msg_color_bold red "ATTENTION! ATTENTION! ATTENTION!"
	msg_color_bold red "ATTENTION! ATTENTION! ATTENTION!"
	msg
	msg "It is very likely that your boot partition is corrupted"
	msg "Rolling back the boot partition using the backup boot image"
	msg

	for attempt in 1 2; do
		msg "- Rollback attempt $attempt:"
		msg_nonewline "   Rollback result: "
		write_partition "boot" /boot_backup.img $boot_partmtd && { msg_color green "good :) You are safe now!" ; return 1 ; } || msg_color red "bad"
	done

	msg_color_bold red "Rollback failed twice. Sorry, your flash chip is probably corrupted"
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
