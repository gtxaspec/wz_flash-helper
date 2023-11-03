#!/bin/sh
#
# Description: Execute user custom script
#

execute_custom_script() {
	msg "custom_script value is set to $custom_script"
	
	[ ! -f /sdcard/$custom_script ] && { msg "Custom script file is missing" ; return 1 ; }
	[[ "$dry_run" == "yes" ]] && { msg "Custom script does not run when dry run is active" ; return 1 ; }

	msg
	msg "---------- Begin custom script ----------"
	msg "Running script: $(basename $custom_script)"
	msg
	source /sdcard/$custom_script || return 1
	msg
}

execute_custom_script || return 1
