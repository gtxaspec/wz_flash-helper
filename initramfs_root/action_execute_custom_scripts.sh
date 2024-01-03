#!/bin/sh
#
# Execute user-custom scripts


function execute_custom_scripts() {
	msg_nonewline "custom_scripts is set to " && msg_color cyan "$custom_scripts"

	[[ "$dry_run" == "yes" ]] && { msg_color lightbrown "Custom scripts are not run when dry run is active" ; return 0 ; }

	msg
	msg_color_bold blue ":: Starting custom scripts"
	for custom_scriptlet in $custom_scripts; do
		msg_color_bold_nonewline white "> Running script: "
		msg_color cyan "$custom_scriptlet"

		msg
		[ ! -f $prog_dir/scripts/$custom_scriptlet ] && { msg_color red "Script file is missing" ; return 1 ; }
		grep -q $'\r' $prog_dir/scripts/$custom_scriptlet && dos2unix $prog_dir/scripts/$custom_scriptlet

		source $prog_dir/scripts/$custom_scriptlet || return 1
		msg
	done
}

execute_custom_scripts || return 1
