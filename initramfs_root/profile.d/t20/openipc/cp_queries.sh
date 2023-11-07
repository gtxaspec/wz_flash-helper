#!/bin/sh
#
# Description: This script contains functions to query partition mapping, partition image filenames and user restore options
#

function get_cp_partnum() {
# Description: Return mtd mapping number of the queried partition name
# Syntax: get_cp_partnum <partname>
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

function get_cp_partfstype() {
# Description: Return fstype of the queried partition name
# Syntax: get_cp_partfstype <partname>
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

function get_cp_restore_opt_value() {
# Description: Return user option to decide if the queried partiton will be restored
# Do not include boot partition
# Syntax: get_cp_restore_opt_value <partname>
	local partname="$1"
	case "$1" in
		"env")
			echo -n "$restore_openipc_env" ;;
		"kernel")
			echo -n "$restore_openipc_kernel" ;;
		"rootfs")
			echo -n "$restore_openipc_rootfs" ;;
		"rootf_data")
			echo -n "$restore_openipc_rootfs_data" ;;
	esac
}


function get_cp_partmtd() {
# Description: Return mtd device of the queried partition name
# Syntax: get_cp_partmtd <partname>
	local partname="$1"
	local partnum=$(get_cp_partnum $partname)
	
	echo -n "/dev/mtd$partnum"	
}

function get_cp_partmtdblock() {
# Description: Return mtdblock device of queried partition
# Syntax: get_cp_partmtdblock <partname>
	local partname="$1"
	local partnum=$(get_cp_partnum $partname)
	
	echo -n "/dev/mtdblock$partnum"	
}

function get_cp_partimg() {
# Description: Return filename of the partition image for the queried partition name
# Syntax: get_openipc_partimg <partname>
	local partname="$1"
	
	echo -n "${current_profile}_${chip_group}_${partname}.bin"
}
