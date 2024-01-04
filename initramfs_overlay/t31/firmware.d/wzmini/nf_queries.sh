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
			echo -n "13" ;;
		"rootfs")
			echo -n "14" ;;
		"configs")
			echo -n "15" ;;
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
		"rootfs")
			echo -n "squashfs" ;;
		"configs")
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
