#!/bin/sh
#
# Description: Execute user custom script
#

execute_custom_script() {
	msg "custom_script value is set to $custom_script"
	
	[ ! -f /sdcard/$custom_script ] && { msg "Custom script file is missing" ; return 1 ; }
	[[ "$dry_run" == "yes" ]] && { msg "Custom script does not run when dry run is active" ; return 1 ; }

	msg "Executing custom script... "
	/sdcard/$custom_script && msg "done" || { msg "failed" ; msg "Custom script did not run properly" ; return 1 ; }
}

execute_custom_script || return 1
