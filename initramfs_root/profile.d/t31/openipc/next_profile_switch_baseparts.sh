#!/bin/sh
#
# Description: This script returns tasks of the queried partition that need to be done on a minimal working firmware
#

function get_np_partoperation() {
# Description: Return task will be done with queried partition when switching profile
# Syntax: get_next_profile_switch <partname>
	case "$1" in
		"boot")
			echo -n "write" ;;
		"env")
			echo -n "write" ;;
		"kernel")
			echo -n "write" ;;
		"rootfs")
			echo -n "write" ;;
		"rootfs_data")
			echo -n "format" ;;
	esac
}

