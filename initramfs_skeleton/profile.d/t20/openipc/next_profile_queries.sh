#!/bin/sh
#
# Description: This script contains functions to query partition mapping, partition image filenames and user restore options
#

function get_next_profile_partnum() {
# Description: Return mtd mapping number of the queried partition name
	local partname="$1"
	case "$1" in
		"boot")
			echo -n "0" ;;
		"env")
			echo -n "2" ;;
		"kernel")
			echo -n "3" ;;
		"rootfs")
			echo -n "4" ;;
		"rootfs_data")
			echo -n "5" ;;
	esac
}

function get_next_profile_partmtd() {
# Description: Return mtd device of the queried partition name
# Syntax: get_next_profile_partmtd <partname>
	local partname="$1"
	local partnum=$(get_next_profile_partnum $partname)
	
	echo -n "/dev/mtd$partnum"	
}

function get_next_profile_partimg() {
# Description: Return filename of the partition image for the queried partition name
# Syntax: get_openipc_partimg <partname> <>
	local partname="$1"
	
	echo -n "${next_profile}_${partname}.bin"
}

