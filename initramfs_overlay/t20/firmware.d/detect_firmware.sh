#!/bin/sh
#
# Description: Detect the current profile by analyzing uboot strings
#

function detect_profile() {
	msg
	if grep -q "demo.bin" /boot_backup.img.strings ; then # Stock Cam v2 & Cam Pan
		msg "Detected stock Wyze Cam Pan v2 or Wyze Cam Pan uboot"
		current_profile="stock"

	elif grep -q "OpenIPC" /boot_backup.img.strings ; then
		msg "Detected OpenIPC uboot"
		current_profile="openipc"
	else
		msg_color_bold red "No known uboot string is found on boot partition, failed to detect current profile"
		return 1
	fi

	if [[ "$current_profile" == "stock" ]]; then
		mkdir -p /rootfs_mnt
		mount -o ro -t squashfs /dev/mtdblock17 /rootfs_mnt || { msg_color_bold red "Unable to mount rootfs" ; return 1 ; }
		if [ "$(ls -A /rootfs_mnt/system)" ]; then
			msg_color lightbrown "Found wz_mini on rootfs"
			current_profile="wzmini"
		fi
		umount /rootfs_mnt && rmdir /rootfs_mnt
	fi
}

detect_profile || return 1
