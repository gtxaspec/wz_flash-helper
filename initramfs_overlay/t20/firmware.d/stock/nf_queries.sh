#!/bin/sh
#
# Description: This script contains functions to query partition mapping, partition image filenames, and user restore options
#

function get_nf_partnum() {
# Description: Return the mtdmapping number of the queried partition name
# Syntax: get_nf_partnum <partname>
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

function get_nf_partfstype() {
# Description: Return the fstype of the queried partition name
# Syntax: get_nf_partfstype <partname>
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

function get_nf_partmtd() {
# Description: Return the mtd device of the queried partition name
# Syntax: get_nf_partmtd <partname>
	local partname="$1"
	local partnum=$(get_nf_partnum $partname)

	echo -n "/dev/mtd$partnum"
}

function get_nf_partmtdblock() {
# Description: Return the mtdblock device of the queried partition
# Syntax: get_cf_partmtdblock <partname>
	local partname="$1"
	local partnum=$(get_nf_partnum $partname)

	echo -n "/dev/mtdblock$partnum"
}

function get_nf_partimg() {
# Description: Return filename of the partition image for the queried partition name
# Syntax: get_openipc_partimg <partname>
	local partname="$1"

	echo -n "${next_firmware}_${chip_group}_${partname}.bin"
}

