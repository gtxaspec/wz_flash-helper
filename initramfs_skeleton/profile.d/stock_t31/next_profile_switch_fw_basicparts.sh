#!/bin/sh
#
# Description: This script returns tasks of the queried partition that need to be done on a working firmware with minimal written
#

function get_next_profile_part_operation() {
# Description: Return task will be done with queried partition when switching firmware
# Syntax: get_next_profile_switch <partname>
	case "$1" in
		"boot")
			echo -n "write" ;;
		"kernel")
			echo -n "write" ;;
		"rootfs")
			echo -n "write" ;;
		"app")
			echo -n "write" ;;
		"kback")
			echo -n "leave" ;;
		"aback")
			echo -n "leave" ;;
		"cfg")
			echo -n "write" ;;
		"para")
			echo -n "write" ;;
	esac
}

