#!/bin/sh
# Description: Execute user custom script



msg "custom_script value is set to \"$custom_script\""
	
if [ -f /sdcard/$custom_script ]; then
	if [[ "$dry_run" == "yes" ]]; then
		msg "Custom script does not run when dry run is active"
	else
		msg "Executing custom script"
		/sdcard/$custom_script || { msg "Custom script did not run properly" ; return 1 ; }
	fi
else
	msg "Custom script file is missing"
fi

