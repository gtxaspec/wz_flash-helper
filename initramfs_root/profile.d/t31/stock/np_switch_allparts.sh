#!/bin/sh
#
# Description: This script returns "write" operation for all queried partitions
#

function get_np_partoperation() {
# Description: Return task will be done with the queried partition when switching profile
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
