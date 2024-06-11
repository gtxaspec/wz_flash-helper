#!/bin/sh
#
# Description: Detect "chip group" to download the correct thingino U-boot/build
#

function detect_chip_group() {
	case $chip_name in
		t31x|t31zl|t31zx)
			chip_group="t31x"
			;;
		t31a)
			chip_group="t31a"
			;;
		*)
			msg_color_bold red "Camera chip name $chip_name belongs to no group"
			return 1
			;;
	esac
}

detect_chip_group || return 1
