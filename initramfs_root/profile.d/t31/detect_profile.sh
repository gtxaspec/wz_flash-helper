#!/bin/sh
#
# Description: Detect the current profile by analyzing uboot strings
#

function detect_profile() {
	msg
	if grep -q "demo_wcv3.bin" /boot_backup.img.strings ; then # Stock Cam v3
		msg "The camera uboot is stock Cam v3"
		current_profile="stock"
	
	elif grep -q "recovery_wcpv2.bin" /boot_backup.img.strings ; then # Stock Cam Pan v2
		msg "The camera uboot is stock Cam Pan v2"
		current_profile="stock"
	
	elif grep -q "factory_t31_0P3N1PC_kernel" /boot_backup.img.strings ; then
		msg "The camera uboot is OpenIPC for T31"
		current_profile="openipc"
	else
		msg_color_bold red "Unable to detect current profile by analyzing uboot strings"
		return 1
	fi
	
	if [[ "$current_profile" == "stock" ]]; then
		mkdir -p /rootfs_mnt
		mount -o ro -t squashfs /dev/mtdblock14 /rootfs_mnt || { msg_color_bold red "Unable to mount rootfs" ; return 1 ; }
		if [ -d /rootfs_mnt/opt/wz_mini ]; then
			msg_color lightbrown "wzmini has been found on rootfs"
			current_profile="wzmini"
		fi
		umount /rootfs_mnt && rmdir /rootfs_mnt
	fi
}

detect_profile || return 1
