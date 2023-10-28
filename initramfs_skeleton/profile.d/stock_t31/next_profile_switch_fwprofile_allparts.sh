#!/bin/sh
#
# Description: This script returns "write" task for all queried partitions
#

function get_next_profile_switch() {
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
			echo -n "write" ;;
		"aback")
			echo -n "write" ;;
		"cfg")
			echo -n "write" ;;
		"para")
			echo -n "write" ;;
	esac
}

