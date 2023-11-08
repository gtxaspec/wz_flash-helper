#!/bin/sh
#
# Description: Execute user-custom scripts
#

function execute_custom_scripts() {
	msg "custom_scripts value is set to \"$custom_scripts\""
	
	[[ "$dry_run" == "yes" ]] && { msg "Custom scripts are not run when dry run is active" ; return 1 ; }

	msg
	msg "---------- Begin of custom scripts ----------"
	for custom_scriptlet in $custom_scripts ; do
		msg "Running script: $custom_scriptlet"
		msg
		[ ! -f $prog_dir/scripts/$custom_scriptlet ] && { msg " - Script file is missing" ; return 1 ; }
		source $prog_dir/scripts/$custom_scriptlet || return 1
		msg
	done
	msg "----------- End of custom scripts -----------"
	msg
}

execute_custom_scripts || return 1
