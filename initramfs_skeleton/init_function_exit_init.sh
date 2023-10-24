#!/bin/sh



function exit_init() {
# Description: Move initramfs log to SD card and reboot
	msg
	msg "---------- Exit init ----------"
	move_continue_boot_img_file
	move_flash_tool_boot_img_file
	if [[ "$switch_fw" == "yes" ]] && [[ "$current_fw_type" == "stock" ]] && [[ "$switch_fw_to" == "openipc" ]]; then
		check_and_fix_invalid_openipc_boot_part
	fi
	msg "Initramfs init is finished! Exiting now"
	[ -f /tmp/initramfs.log ] && cp /tmp/initramfs.log $log_file
	[ -f /tmp/initramfs_serial.log ] && cp /tmp/initramfs_serial.log $log_file_serial
	[ -f /tmp/initramfs_missing-config-file.log ] && cp /tmp/initramfs_missing-config-file.log $log_file_fallback
	sync
	umount /sdcard
	sleep 1
	reboot -f # Reboot immediately to prevent init from continuing
	sleep 10 # This prevents init from continuing after exit_init is finished but the camera has not rebooted immediately
}
