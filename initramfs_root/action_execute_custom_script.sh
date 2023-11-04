#!/bin/sh
#
# Description: Execute user custom script
#

function execute_custom_script() {
	msg "custom_script value is set to $custom_script"
	
	[ ! -f $prog_dir/scripts/$custom_script ] && { msg "Custom script file is missing" ; return 1 ; }
	[[ "$dry_run" == "yes" ]] && { msg "Custom script does not run when dry run is active" ; return 1 ; }

	msg
	msg "---------- Begin custom script ----------"
	msg "Running script: $(basename $custom_script)"
	msg
	source $prog_dir/scripts/$custom_script || return 1
	msg "----------- End custom script -----------"
	msg
}

execute_custom_script || return 1
