#!/bin/sh
#
# Description: Detect the current profile by analyzing uboot strings
#

function detect_profile() {
	msg
	if grep -q "demo_wcv3.bin" /boot_backup.img.strings ; then # Stock Cam v3
		msg "Detected stock Wyze Cam v3 uboot"
		current_profile="stock"
	
	elif grep -q "recovery_wcpv2.bin" /boot_backup.img.strings ; then # Stock Cam Pan v2
		msg "Detected stock Wyze Cam Pan v2 uboot"
		current_profile="stock"
	
	elif grep -q "factory_t31_0P3N1PC_kernel" /boot_backup.img.strings ; then
		msg "Detected OpenIPC T31 uboot"
		current_profile="openipc"
	else
		msg_color_bold red "No known uboot string is found on boot partition, failed to detect current profile"
		return 1
	fi
	
	if [[ "$current_profile" == "stock" ]]; then
		mkdir -p /rootfs_mnt
		mount -o ro -t squashfs /dev/mtdblock14 /rootfs_mnt || { msg_color_bold red "Unable to mount rootfs" ; return 1 ; }
		if [ -d /rootfs_mnt/opt/wz_mini ]; then
			msg_color lightbrown "Found wz_mini on rootfs"
			current_profile="wzmini"
		fi
		umount /rootfs_mnt && rmdir /rootfs_mnt
	fi
}

detect_profile || return 1
