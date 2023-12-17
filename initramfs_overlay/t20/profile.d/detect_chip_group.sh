#!/bin/sh
#
# Description: Detect "chip group" to download the correct OpenIPC uboot/build
#

function detect_chip_group() {
	case $chip_name in
		t20|t20x)
			chip_group="t20x"
			;;
		*)
			msg_color_bold red "Camera chip name $chip_name belongs to no group"
			return 1
			;;
	esac
}

detect_chip_group || return 1
