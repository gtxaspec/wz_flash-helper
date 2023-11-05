#!/bin/sh
#
# Description: Execute user custom script
#

function execute_custom_scripts() {
	msg "custom_scripts value is set to \"$custom_scripts\""
	
	[[ "$dry_run" == "yes" ]] && { msg "Custom scripts are not run when dry run is active" ; return 1 ; }

	msg
	msg "---------- Begin custom script ----------"
	for custom_scriptlet in $custom_scripts ; do
		[ ! -f $prog_dir/scripts/$custom_scriptlet ] && { msg "Custom script file $custom_scriptlet is missing" ; return 1 ; }
		msg "Running script: $custom_scriptlet"
		msg
		source $prog_dir/scripts/$custom_scriptlet || return 1
		msg
	done
	msg "----------- End custom script -----------"
	msg
}

execute_custom_scripts || return 1
