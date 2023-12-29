#!/bin/sh
#
# Description: Make a copy of the user-specified SD card kernel and rename it to let it be booted by uboot on the next boot
#

function copy_new_sdcard_kernel() {
	[ ! -f /sdcard/$new_sdcard_kernel ] && { msg_color red "File /sdcard/$new_sdcard_kernel is missing" ; return 1 ; }
	[[ "$switch_profile" == "yes" ]] && { msg_color lightbrown "New SD card kernel will not be copied when switch_profile is enabled" ; return 1 ; }
	[[ "$dry_run" == "yes" ]] && { msg_color lightbrown "New SD card kernel is not copied when dry run is active" ; return 0 ; }

	msg
	msg_nonewline "Copying "
	msg_color_nonewline cyan "/sdcard/$new_sdcard_kernel "
	msg_nonewline "to "
	msg_color_nonewline cyan "/sdcard/$cp_sdcard_kernel_name"
	msg_nonewline "... "

	cp /sdcard/$new_sdcard_kernel /sdcard/$cp_sdcard_kernel_name && msg_color green "done" || { msg_color red "failed" ; return 1 ; }
}

copy_new_sdcard_kernel || return 1
