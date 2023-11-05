#!/bin/sh
#
# Description: This script contains functions to query partition mapping, partition image filenames and user restore options
#

function get_next_profile_partnum() {
# Description: Return mtd mapping number of the queried partition name
# Syntax: get_next_profile_partnum <partname>
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

function get_next_profile_partfstype() {
# Description: Return fstype of the queried partition name
# Syntax: get_next_profile_partfstype <partname>
	local partname="$1"
	case "$1" in
		"boot")
			echo -n "raw" ;;
		"env")
			echo -n "raw" ;;
		"kernel")
			echo -n "raw" ;;
		"rootfs")
			echo -n "squashfs" ;;
		"rootfs_data")
			echo -n "jffs2" ;;
	esac
}

function get_next_profile_partmtd() {
# Description: Return mtd device of the queried partition name
# Syntax: get_next_profile_partmtd <partname>
	local partname="$1"
	local partnum=$(get_next_profile_partnum $partname)
	
	echo -n "/dev/mtd$partnum"	
}

function get_next_profile_partmtdblock() {
# Description: Return mtdblock device of queried partition
# Syntax: get_next_profile_partmtdblock <partname>
	local partname="$1"
	local partnum=$(get_current_profile_partnum $partname)
	
	echo -n "/dev/mtdblock$partnum"	
}

function get_next_profile_partimg() {
# Description: Return filename of the partition image for the queried partition name
# Syntax: get_openipc_partimg <partname> <>
	local partname="$1"
	
	echo -n "${next_profile}_${chip_group}_${partname}.bin"
}
