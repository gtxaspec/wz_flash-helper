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
			echo -n "10" ;;
		"rootfs")
			echo -n "11" ;;
		"app")
			echo -n "12" ;;
		"kback")
			echo -n "13" ;;
		"aback")
			echo -n "14" ;;
		"cfg")
			echo -n "15" ;;
		"para")
			echo -n "16" ;;
	esac
}

function get_current_profile_partfstype() {
# Description: Return fstype of the queried partition name
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
			echo -n "raw" ;;
		"aback")
			echo -n "raw" ;;
		"cfg")
			echo -n "jffs2" ;;
		"para")
			echo -n "jffs2" ;;
	esac
}

function get_current_profile_restore_opt_value() {
# Description: Return user option to decide if the queried partiton will be restored
# Syntax: get_current_profile_restore_opt_value <partname>
	local partname="$1"
	case "$1" in
		"kernel")
			echo -n "/dev/mtd10" ;;
		"rootfs")
			echo -n "/dev/mtd11" ;;
		"app")
			echo -n "/dev/mtd12" ;;
		"kback")
			echo -n "/dev/mtd13" ;;
		"aback")
			echo -n "/dev/mtd14" ;;
		"cfg")
			echo -n "/dev/mtd15" ;;
		"para")
			echo -n "/dev/mtd16" ;;
		"[partnameA]")
			echo -n "$restore_[FW_PROFILE]_[partnameA]" ;;
		"[partnameB]")
			echo -n "$restore_[FW_partnameB]_[PROFILE]" ;;
		"[partnameC]")
			echo -n "$restore_[FW_PROFILE]_[partnameC]" ;;
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

