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
		"kernel")
			echo -n "6" ;;
		"rootfs")
			echo -n "7" ;;
		"app")
			echo -n "8" ;;
		"kback")
			echo -n "9" ;;
		"aback")
			echo -n "10" ;;
		"cfg")
			echo -n "11" ;;
		"para")
			echo -n "12" ;;
	esac
}

function get_cp_partfstype() {
# Description: Return fstype of the queried partition name
# Syntax: get_cp_partfstype <partname>
	local partname="$1"
	case "$1" in
		"boot")
			echo -n "raw" ;;
		"kernel")
			echo -n "raw" ;;
		"rootfs")
			echo -n "squashfs" ;;
		"app")
			echo -n "squasfs" ;;
		"kback")
			echo -n "vfat" ;;
		"aback")
			echo -n "raw" ;;
		"cfg")
			echo -n "jffs2" ;;
		"para")
			echo -n "jffs2" ;;
	esac
}

function get_cp_restore_opt_value() {
# Description: Return user option to decide if the queried partiton will be restored
# Syntax: get_cp_restore_opt_value <partname>
	local partname="$1"
	case "$1" in
		"kernel")
			echo -n "$restore_stock_kernel" ;;
		"rootfs")
			echo -n "$restore_stock_rootfs" ;;
		"app")
			echo -n "$restore_stock_app" ;;
		"kback")
			echo -n "$restore_stock_kback" ;;
		"aback")
			echo -n "$restore_stock_aback" ;;
		"cfg")
			echo -n "$restore_stock_cfg" ;;
		"para")
			echo -n "$restore_stock_para" ;;
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

