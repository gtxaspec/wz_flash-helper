#!/bin/sh
#
# Description: This script contains functions to query partition mapping, partition image filenames, and user restore options
#

function get_cf_partnum() {
# Description: Return the mtdmapping number of the queried partition name
# Syntax: get_cf_partnum <partname>
	local partname="$1"
	case "$1" in
		"boot")
			echo -n "0" ;;
		"kernel")
			echo -n "4" ;;
		"rootfs")
			echo -n "5" ;;
		"app")
			echo -n "6" ;;
		"kback")
			echo -n "7" ;;
		"aback")
			echo -n "8" ;;
		"cfg")
			echo -n "9" ;;
		"para")
			echo -n "10" ;;
	esac
}

function get_cf_partfstype() {
# Description: Return the fstype of the queried partition name
# Syntax: get_cf_partfstype <partname>
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

function get_cf_restore_opt_value() {
# Description: Return user option to decide if the queried partition will be restored
# Syntax: get_cf_restore_opt_value <partname>
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


function get_cf_partmtd() {
# Description: Return the mtd device of the queried partition name
# Syntax: get_cf_partmtd <partname>
	local partname="$1"
	local partnum=$(get_cf_partnum $partname)

	echo -n "/dev/mtd$partnum"
}

function get_cf_partmtdblock() {
# Description: Return the mtdblock device of the queried partition
# Syntax: get_cf_partmtdblock <partname>
	local partname="$1"
	local partnum=$(get_cf_partnum $partname)

	echo -n "/dev/mtdblock$partnum"
}

function get_cf_partimg() {
# Description: Return filename of the partition image for the queried partition name
# Syntax: get_cf_partimg <partname>
	local partname="$1"

	echo -n "${current_firmware}_${chip_group}_${partname}.bin"
}
