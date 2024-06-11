#!/bin/sh
#
# Description: Detect the current firmware by analyzing U-boot strings
#

function detect_firmware() {
	msg
	if grep -q "demo_wcv3.bin" /boot_backup.img.strings ; then # Stock Cam v3
		msg "Detected stock Wyze Cam v3 U-boot"
		current_firmware="stock"

	elif grep -q "recovery_wcpv2.bin" /boot_backup.img.strings ; then # Stock Cam Pan v2
		msg "Detected stock Wyze Cam Pan v2 U-boot"
		current_firmware="stock"

	elif grep -q "Ingenic U-Boot Flex SPL" /boot_backup.img.strings ; then
		msg "Detected thingino U-boot"
		current_firmware="thingino"
	else
		msg_color_bold red "No known U-boot string is found on boot partition, failed to detect current firmware"
		return 1
	fi
}

detect_firmware || return 1
