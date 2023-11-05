#!/bin/sh
#
# Detect "chip group" to download correct OpenIPC uboot/build
#

function detect_chip_group() {
	case $chip_name in
		t20|t20x)
			chip_group="t20x"
			;;
		t31x|t31zl|t31zx)
			chip_group="t31x"
			;;
		t31a)
			chip_group="t31a"
			;;
		*)
			msg "Your chip name belongs to no group, exiting... "
			return 1
			;;
	esac
}

detect_chip_group || return 1
