#!/bin/sh
#
# Description: This script contains functions to query partition mapping, partition image filenames and user restore options
#

function get_current_profile_partnum() {
# Description: Return mtd mapping number of the queried partition name
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

function get_current_profile_restore_opt_value() {
# Description: Return user option to decide if the queried partiton will be restored
# Syntax: get_current_profile_restore_opt_value <partname>
	local partname="$1"
	case "$1" in
		"boot")
			echo -n "$restore_stock_t20_boot" ;;
		"kernel")
			echo -n "$restore_stock_t20_kernel" ;;
		"root")
			echo -n "$restore_stock_t20_root" ;;
		"driver")
			echo -n "$restore_stock_t20_driver" ;;
		"appfs")
			echo -n "$restore_stock_t20_appfs" ;;
		"backupk")
			echo -n "$restore_stock_t20_backupk" ;;
		"backupd")
			echo -n "$restore_stock_t20_backupd" ;;
		"backupa")
			echo -n "$restore_stock_t20_backupa" ;;
		"config")
			echo -n "$restore_stock_t20_config" ;;
		"para")
			echo -n "$restore_stock_t20_para" ;;
	esac
}


function get_current_profile_partmtd() {
# Description: Return mtd device of the queried partition name
# Syntax: get_current_profile_partmtd <partname>
	local partname="$1"
	local partnum=$(get_current_profile_partnum $partname)
	
	echo -n "/dev/mtd$partnum"	
}

function get_current_profile_partmtdblock() {
# Description: Return mtdblock device of queried partition
# Syntax: get_current_profile_partmtdblock <partname>
	local partname="$1"
	local partnum=$(get_current_profile_partnum $partname)
	
	echo -n "/dev/mtdblock$partnum"	
}

function get_current_profile_partimg() {
# Description: Return filename of the partition image for the queried partition name
# Syntax: get_openipc_partimg <partname> <>
	local partname="$1"
	local current_profile="$2"
	
	echo -n "${current_profile}_${partname}.bin"
}

