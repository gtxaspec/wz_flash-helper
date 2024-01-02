#!/bin/sh
#
# Switch profile operation


function osp_validate_restore_partition_images() {
	msg_color_bold white "> Making sure that all needed partition images exist and are valid"

	cd $np_images_path

	# Verify all partition images first to make sure they are all valid before flashing them
	for partname in $np_all_partname_list; do
		if [[ "$(get_np_partoperation $partname)" == "write" ]]; then
			local infile_name=$(get_np_partimg $partname)

			msg_nonewline "    Verifying "
			msg_color_nonewline brown "$infile_name... "
			[ ! -f $infile_name ] && { msg_color red "file is missing" ; return 1 ; }
			sha256sum -c $infile_name.sha256sum && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
		fi
	done
	msg
}

function osp_validate_written_boot_partition() {
# Description: Validate if the written boot partition is the same as the boot partition image used to write
	local partname="boot"
	local partnum="0"
	local verifyfile_basename=$(get_np_partimg $partname)
	local verifyfile="$np_images_path/$verifyfile_basename"

	validate_written_partition $partname $partnum $verifyfile || return 1
}

function osp_main() {
	[[ "$restore_partitions" == "yes" ]] && { msg_color red "Restore and Switch_profile operations are conflicted, please enable only one option at a time" ; return 1 ; }
	[[ "$current_profile" == "$next_profile" ]] && { msg_color red "next_profile value is same as current_profile, aborting switch profile" ; return 1 ; }
	[ -z "$next_profile" ] && { msg_color red "next_profile value is empty, aborting switch profile" ; return 1 ; }
	[ ! -d /profile.d/$next_profile ] && { msg_color red "$next_profile profile is not supported, aborting switch profile" ; return 1 ; }

	source /profile.d/$next_profile/np_variables.sh
	source /profile.d/$next_profile/np_queries.sh

	if [[ "$switch_profile_with_all_partitions" == "yes" ]]; then
		source /profile.d/$next_profile/np_switch_allparts.sh
	else
		source /profile.d/$next_profile/np_switch_baseparts.sh
	fi

	/bg_blink_led_red_and_blue &
	local red_and_blue_leds_pid="$!"

	msg
	msg_color_bold blue ":: Starting switch profile operation"
	msg_color_bold_nonewline white "Switch profile: "
	msg_color_bold_nonewline lightred "$current_profile" && msg_nonewline " -> " && msg_color_bold lightred "$next_profile"
	msg_color_bold_nonewline white "Source directory: " && msg_color cyan "$np_images_path"

	msg
	osp_validate_restore_partition_images || return 1

	msg_color_bold white "> Writing partition images"
	for partname in $np_all_partname_list; do
		local partoperation=$(get_np_partoperation $partname)
		local partmtd=$(get_np_partmtd $partname)

		case "$partoperation" in
			"write")
				local infile_name=$(get_np_partimg $partname)
				local infile="$np_images_path/$infile_name"
				write_partition $partname $infile $partmtd || return 1
				;;
			"erase")
				erase_partition $partname $partmtd || return 1
				;;
			"format")
				local partfstype=$(get_np_partfstype $partname)
				local partnum=$(get_np_partnum $partname)
				format_partition $partname $partnum $partfstype || return 1
				;;
			"leave")
				leave_partition $partname $partmtd
				;;
		esac
	done

	msg
	[[ "$dry_run" == "yes" ]] && { msg "No need to check for boot partition corruption on dry run mode" ; return 0 ; }
	osp_validate_written_boot_partition || rollback_boot_partition || return 1

	if [ -f /profile.d/$next_profile/post_switch.sh ]; then
		msg
		msg_color_bold white "> Executing post-switch profile script"
		source /profile.d/$next_profile/post_switch.sh || { msg_color red "Executing post-switch profile script failed" ; return 1 ; }
	fi

	sync
	msg
	/bg_turn_off_leds
}

osp_main || return 1
