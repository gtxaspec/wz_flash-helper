#!/bin/sh
#
# Description: This script contains functions to query partition mapping, partition image filenames, and user restore options
#

function get_cp_partnum() {
# Description: Return the mtdmapping number of the queried partition name
# Syntax: get_cp_partnum <partname>
	local partname="$1"
	case "$1" in
		"boot")
			echo -n "0" ;;
		"kernel")
			echo -n "6" ;;
		"root")
			echo -n "7" ;;
		"driver")
			echo -n "8" ;;
		"appfs")
			echo -n "9" ;;
		"backupk")
			echo -n "10" ;;
		"backupd")
			echo -n "11" ;;
		"backupa")
			echo -n "12" ;;
		"config")
			echo -n "13" ;;
		"para")
			echo -n "14" ;;
	esac
}

function get_cp_partfstype() {
# Description: Return the fstype of the queried partition name
# Syntax: get_cp_partfstype <partname>
	local partname="$1"
	case "$1" in
		"boot")
			echo -n "raw" ;;
		"kernel")
			echo -n "raw" ;;
		"root")
			echo -n "squashfs" ;;
		"driver")
			echo -n "squashfs" ;;
		"appfs")
			echo -n "squashfs" ;;
		"backupk")
			echo -n "raw" ;;
		"backupd")
			echo -n "raw" ;;
		"backupa")
			echo -n "jffs2" ;;
		"config")
			echo -n "jffs2" ;;
		"para")
			echo -n "jffs2" ;;
	esac
}

function get_cp_restore_opt_value() {
# Description: Return user option to decide if the queried partition will be restored
# Syntax: get_cp_restore_opt_value <partname>
	local partname="$1"
	case "$1" in
		"boot")
			echo -n "$restore_stock_boot" ;;
		"kernel")
			echo -n "$restore_stock_kernel" ;;
		"root")
			echo -n "$restore_stock_root" ;;
		"driver")
			echo -n "$restore_stock_driver" ;;
		"appfs")
			echo -n "$restore_stock_appfs" ;;
		"backupk")
			echo -n "$restore_stock_backupk" ;;
		"backupd")
			echo -n "$restore_stock_backupd" ;;
		"backupa")
			echo -n "$restore_stock_backupa" ;;
		"config")
			echo -n "$restore_stock_config" ;;
		"para")
			echo -n "$restore_stock_para" ;;
	esac
}

function get_cp_partmtd() {
# Description: Return the mtd device of the queried partition name
# Syntax: get_cp_partmtd <partname>
	local partname="$1"
	local partnum=$(get_cp_partnum $partname)
	
	echo -n "/dev/mtd$partnum"	
}

function get_cp_partmtdblock() {
# Description: Return the mtdblock device of the queried partition
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

