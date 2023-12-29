#!/bin/sh
#
# Description: This script contains functions to query partition mapping, partition image filenames, and user restore options
#

function get_np_partnum() {
# Description: Return the mtdmapping number of the queried partition name
# Syntax: get_np_partnum <partname>
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

function get_np_partfstype() {
# Description: Return the fstype of the queried partition name
# Syntax: get_np_partfstype <partname>
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

function get_np_partmtd() {
# Description: Return the mtd device of the queried partition name
# Syntax: get_np_partmtd <partname>
	local partname="$1"
	local partnum=$(get_np_partnum $partname)

	echo -n "/dev/mtd$partnum"
}

function get_np_partmtdblock() {
# Description: Return the mtdblock device of the queried partition
# Syntax: get_cp_partmtdblock <partname>
	local partname="$1"
	local partnum=$(get_np_partnum $partname)

	echo -n "/dev/mtdblock$partnum"
}

function get_np_partimg() {
# Description: Return filename of the partition image for the queried partition name
# Syntax: get_openipc_partimg <partname>
	local partname="$1"

	echo -n "${next_profile}_${chip_group}_${partname}.bin"
}
