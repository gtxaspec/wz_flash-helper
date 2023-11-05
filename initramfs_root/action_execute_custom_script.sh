#!/bin/sh
#
# Description: Execute user custom script
#

function execute_custom_script() {
	msg "custom_script value is set to $custom_script"
	
	[[ "$dry_run" == "yes" ]] && { msg "Custom script does not run when dry run is active" ; return 1 ; }

	msg
	msg "---------- Begin custom script ----------"
	for custom_scriptlet in $custom_script ; do
		[ ! -f $prog_dir/scripts/$custom_scriptlet ] && { msg "Custom script file $custom_scriptlet is missing" ; return 1 ; }
		msg "Running script: $custom_scriptlet"
		msg
		source $prog_dir/scripts/$custom_scriptlet || return 1
		msg
	done
	msg "----------- End custom script -----------"
	msg
}

execute_custom_script || return 1
