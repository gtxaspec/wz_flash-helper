#!/bin/sh
#
# Restore operation


function or_restore_boot_partition() {
# Description: Restore the boot partition, this option is hidden from restore config files
	[[ ! "$hidden_option_restore_boot" == "yes" ]] && return 0

	local partname="boot"
	local partnum="0"
	local partmtd=$(get_cp_partmtd $partname)
	local infile_name=$(get_cp_partimg $partname)
	local infile="$cp_restore_path/$infile_name"

	msg_tickbox_yes
	msg_color lightbrown "hidden_option_restore_boot is set to Yes"
	write_partition $partname $infile $partmtd || return 1

	validate_written_partition $partname $partnum $infile || rollback_boot_partition || return 1
}

function or_restore_partitions() {
# Description: Restore partitions from partition images
	for partname in $cp_restore_partname_list; do
		local infile_name=$(get_cp_partimg $partname)
		local infile="$cp_restore_path/$infile_name"
		local partmtd=$(get_cp_partmtd $partname)
		local restore_opt_value=$(get_cp_restore_opt_value $partname)

		if [[ "$restore_opt_value" == "yes" ]]; then
			msg_tickbox_yes
			msg "restore_${current_profile}_${partname} is set to Yes"
			write_partition $partname $infile $partmtd || return 1
		else
			msg_tickbox_no
			msg "restore_${current_profile}_${partname} is set to No"
		fi
	done
}

function or_main() {
	prog_restore_config_file="/sdcard/wz_flash-helper/restore/$current_profile.conf"

	[[ "$switch_profile" == "yes" ]] && { msg_color red "Restore and Switch_profile operations are conflicted, please enable only one option at a time" ; return 1 ; }
	[ ! -d $cp_restore_path ] && { msg_color_bold red "$cp_restore_path directory is missing" ; return 1 ; }
	[ ! -f $prog_restore_config_file ] && { msg_color red "$prog_restore_config_file file is missing. Nothing more will be done" ; return 1 ; }

	grep -q $'\r' $prog_restore_config_file && dos2unix $prog_restore_config_file
	source $prog_restore_config_file || { msg_color_bold red "$prog_restore_config_file file is invalid. Nothing will be done" ; return 1 ; }

	/bg_blink_led_red &
	local red_led_pid="$!"

	msg
	msg_color_bold blue ":: Starting restore operation"
	msg_color_bold_nonewline white "Restore source: " && msg_color cyan "$cp_restore_path"

	msg
	msg_color_bold white "> Restoring partitions"
	or_restore_partitions || return 1
	or_restore_boot_partition || return 1
	sync

	msg
	/bg_turn_off_leds.sh
}

or_main || return 1
