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
		"[partnameA]")
			echo -n "[1]" ;;
		"[partnameB]")
			echo -n "[2]" ;;
		"[partnameC]")
			echo -n "[3]" ;;
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
	local current_profile="$2"
	
	echo -n "${current_profile}_${partname}.bin"
}

