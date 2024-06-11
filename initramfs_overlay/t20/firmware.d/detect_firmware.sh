#!/bin/sh
#
# Description: Detect the current firmware by analyzing uboot strings
#

function detect_firmware() {
	msg
	if grep -q "demo.bin" /boot_backup.img.strings ; then # Stock Cam v2 & Cam Pan
		msg "Detected stock Wyze Cam Pan v2 or Wyze Cam Pan uboot"
		current_firmware="stock"

	elif grep -q "Ingenic U-Boot Flex SPL" /boot_backup.img.strings ; then
		msg "Detected thingino uboot"
		current_firmware="thingino"
	else
		msg_color_bold red "No known uboot string is found on boot partition, failed to detect current firmware"
		return 1
	fi
}

detect_firmware || return 1
