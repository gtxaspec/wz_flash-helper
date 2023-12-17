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
			echo -n "15" ;;
		"rootfs")
			echo -n "16" ;;
		"configs")
			echo -n "17" ;;
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
		"rootfs")
			echo -n "squashfs" ;;
		"configs")
			echo -n "jffs2" ;;
	esac
}

function get_cp_restore_opt_value() {
# Description: Return user option to decide if the queried partition will be restored
# Syntax: get_cp_restore_opt_value <partname>
	local partname="$1"
	case "$1" in
		"kernel")
			echo -n "$restore_wzmini_kernel" ;;
		"rootfs")
			echo -n "$restore_wzmini_rootfs" ;;
		"configs")
			echo -n "$restore_wzmini_configs" ;;
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
