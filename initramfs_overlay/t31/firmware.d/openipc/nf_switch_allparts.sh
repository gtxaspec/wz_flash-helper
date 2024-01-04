#!/bin/sh
#
# Description: This script returns "write" operation for all queried partitions
#

function get_nf_partoperation() {
# Description: Return task will be done with the queried partition when switching firmware
# Syntax: get_next_firmware_switch <partname>
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
			echo -n "write" ;;
	esac
}
