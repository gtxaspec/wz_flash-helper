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
		"[partnameA]")
			echo -n "[1]" ;;
		"[partnameB]")
			echo -n "[2]" ;;
		"[partnameC]")
			echo -n "[3]" ;;
	esac
}

function get_current_profile_partfstype() {
# Description: Return fstype of the queried partition name
	local partname="$1"
	case "$1" in
		"boot")
			echo -n "raw" ;;
		"[partnameA]")
			echo -n "vfat" ;;
		"[partnameB]")
			echo -n "jffs2" ;;
		"[partnameC]")
			echo -n "ubi" ;;
	esac
}

function get_current_profile_restore_opt_value() {
# Description: Return user option to decide if the queried partiton will be restored

# Syntax: get_current_profile_restore_opt_value <partname>
	local partname="$1"
	case "$1" in
		"[partnameA]")
			echo -n "$restore_[FW_PROFILE]_[partnameA]" ;;
		"[partnameB]")
			echo -n "$restore_[FW_PROFILE]_[partnameB]" ;;
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

