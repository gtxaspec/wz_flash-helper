#!/bin/sh
#
# Make a copy of the user-specified SD card kernel and rename it to let it be booted by uboot on the next boot


function copy_new_sdcard_kernel() {
	[ ! -f /sdcard/$new_sdcard_kernel ] && { msg_color lightbrown "File /sdcard/$new_sdcard_kernel is missing, skipping" ; return 0 ; }
	[[ "$dry_run" == "yes" ]] && { msg_color lightbrown "New SD card kernel is not copied when dry run is active, skipping" ; return 0 ; }

	[[ "$switch_profile" == "yes" ]] && msg_color lightbrown "Warning: switch_profile is enabled, new SD card kernel might not be compatile with the next profile"

	if [[ "$switch_profile" == "yes" ]]; then
		local new_sdcard_kernel_name=$np_sdcard_kernel_name
	else
		local new_sdcard_kernel_name=$cp_sdcard_kernel_name
	fi

	msg
	msg_nonewline "Copying "
	msg_color_nonewline cyan "/sdcard/$new_sdcard_kernel "
	msg_nonewline "to "
	msg_color_nonewline cyan "/sdcard/$new_sdcard_kernel_name"
	msg_nonewline "... "

	cp /sdcard/$new_sdcard_kernel /sdcard/$new_sdcard_kernel_name && msg_color green "done" || { msg_color red "failed" ; return 1 ; }
}

copy_new_sdcard_kernel || return 1
