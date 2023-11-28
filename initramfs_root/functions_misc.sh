#!/bin/sh
#
# Description: Miscellaneous functions
#

function gen_4digit_id() {
# Description: Return a random number in 1000-9999 range
	shuf -i 1000-9999 -n 1
}

unpad_partimg() {
# Create a partition image with padded blocks removed from a partition image
# Syntax: unpad_partimg <partimg> <blocksize>
	local partimg="$1"
	local blocksize="$2"
	local blocksize=$(( $blocksize * 1024 ))
	
	[ ! -f $partimg ] && { echo "Partition image $partimg is missing" ; return 1 ; }
	
	local partimg_size=$(du -b $partimg | cut -f -1)
	local padding_block=$(dd if=/dev/zero bs=$blocksize count=1 status=none | tr '\0' '\377')
	local partimg_totalblocks=$(( $partimg_size/$blocksize ))
	local partimg_totalblocks_minusone=$(( $partimg_totalblocks - 1 ))

	local block_contents=""
	local padding_blocks_total="0"
	for block in $(seq $partimg_totalblocks_minusone -1 0); do
		block_contents=$(dd if=$partimg bs=$blocksize count=1 skip=$block status=none | tr -d '\000')
		if [[ "$block_contents" == "$padding_block" ]]; then
			padding_blocks_total=$(( $padding_blocks_total + 1 ))
			echo "Block $block is padded"
		else
			break
		fi
	done

	echo "Number of data blocks: $(( $partimg_totalblocks - $padding_blocks_total ))"
	echo "Number of padded blocks: $padding_blocks_total"
	dd if=$partimg of=$partimg.unpadded bs=$blocksize count=$(( $partimg_totalblocks - $padding_blocks_total )) status=none
	echo "Output file: $partimg.unpadded"
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
