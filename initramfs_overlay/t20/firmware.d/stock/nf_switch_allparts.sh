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
		"kernel")
			echo -n "write" ;;
		"root")
			echo -n "write" ;;
		"driver")
			echo -n "write" ;;
		"appfs")
			echo -n "write" ;;
		"backupk")
			echo -n "write" ;;
		"backupd")
			echo -n "write" ;;
		"backupa")
			echo -n "write" ;;
		"config")
			echo -n "write" ;;
		"para")
			echo -n "write" ;;
	esac
}

