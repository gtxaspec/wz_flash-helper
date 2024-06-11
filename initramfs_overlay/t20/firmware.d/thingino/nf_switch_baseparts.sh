#!/bin/sh
#
# Description: This script returns tasks of the queried partition that need to be done on a minimal working firmware
#

function get_nf_partoperation() {
# Description: Return task will be done with the queried partition when switching firmware
# Syntax: get_next_firmware_switch <partname>
	case "$1" in
		"boot")
			echo -n "write" ;;
		"env")
			echo -n "erase" ;;
		"ota")
			echo -n "write" ;;
	esac
}
