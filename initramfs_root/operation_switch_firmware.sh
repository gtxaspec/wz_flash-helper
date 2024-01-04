#!/bin/sh
#
# Switch firmware operation


function osf_validate_restore_partition_images() {
	msg_color_bold white "> Making sure that all needed partition images exist and are valid"

	cd $nf_images_path

	# Verify all partition images first to make sure they are all valid before flashing them
	for partname in $nf_all_partname_list; do
		if [[ "$(get_nf_partoperation $partname)" == "write" ]]; then
			local infile_name=$(get_nf_partimg $partname)

			msg_nonewline "    Verifying "
			msg_color_nonewline brown "$infile_name... "
			[ ! -f $infile_name ] && { msg_color red "file is missing" ; return 1 ; }
			sha256sum -c $infile_name.sha256sum && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
		fi
	done
	msg
}

function osf_validate_written_boot_partition() {
# Description: Validate if the written boot partition is the same as the boot partition image used to write
	local partname="boot"
	local partnum="0"
	local verifyfile_basename=$(get_nf_partimg $partname)
	local verifyfile="$nf_images_path/$verifyfile_basename"

	validate_written_partition $partname $partnum $verifyfile || return 1
}

function osf_main() {
	[[ "$restore_partitions" == "yes" ]] && { msg_color red "Restore and switch_firmware operations are conflicted, please enable only one option at a time" ; return 1 ; }
	[[ "$current_firmware" == "$next_firmware" ]] && { msg_color red "next_firmware value is same as current_firmware, aborting switch firmware" ; return 1 ; }
	[ -z "$next_firmware" ] && { msg_color red "next_firmware value is empty, aborting switch firmware" ; return 1 ; }
	[ ! -d /firmware.d/$next_firmware ] && { msg_color red "$next_firmware firmware is not supported, aborting switch firmware" ; return 1 ; }

	source /firmware.d/$next_firmware/nf_variables.sh
	source /firmware.d/$next_firmware/nf_queries.sh

	if [[ "$switch_firmware_with_all_partitions" == "yes" ]]; then
		source /firmware.d/$next_firmware/nf_switch_allparts.sh
	else
		source /firmware.d/$next_firmware/nf_switch_baseparts.sh
	fi

	/bg_blink_led_red_and_blue &
	local red_and_blue_leds_pid="$!"

	msg
	msg_color_bold blue ":: Starting switch firmware operation"
	msg_color_bold_nonewline white "Switch firmware: "
	msg_color_bold_nonewline lightred "$current_firmware" && msg_nonewline " -> " && msg_color_bold lightred "$next_firmware"
	msg_color_bold_nonewline white "Source directory: " && msg_color cyan "$nf_images_path"

	msg
	osf_validate_restore_partition_images || return 1

	msg_color_bold white "> Writing partition images"
	for partname in $nf_all_partname_list; do
		local partoperation=$(get_nf_partoperation $partname)
		local partmtd=$(get_nf_partmtd $partname)

		case "$partoperation" in
			"write")
				local infile_name=$(get_nf_partimg $partname)
				local infile="$nf_images_path/$infile_name"
				write_partition $partname $infile $partmtd || return 1
				;;
			"erase")
				erase_partition $partname $partmtd || return 1
				;;
			"format")
				local partfstype=$(get_nf_partfstype $partname)
				local partnum=$(get_nf_partnum $partname)
				format_partition $partname $partnum $partfstype || return 1
				;;
			"leave")
				leave_partition $partname $partmtd
				;;
		esac
	done

	msg
	[[ "$dry_run" == "yes" ]] && { msg "No need to check for boot partition corruption on dry run mode" ; return 0 ; }
	osf_validate_written_boot_partition || rollback_boot_partition || return 1

	if [ -f /firmware.d/$next_firmware/post_switch.sh ]; then
		msg
		msg_color_bold white "> Executing post-switch firmware script"
		source /firmware.d/$next_firmware/post_switch.sh || { msg_color red "Executing post-switch firmware script failed" ; return 1 ; }
	fi

	sync
	msg
	/bg_turn_off_leds
}

osf_main || return 1
