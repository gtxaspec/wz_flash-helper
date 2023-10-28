#!/bin/sh
#
#
#

function detect_hardware() {
# Description: Detect chip family and current firmware to run later operations correctly
	chip_name=$(ipcinfo-mips32 --chip-name)
	chip_family=$(ipcinfo-mips32 --family)
	flash_type=$(ipcinfo-mips32 --flash-type)
}

function detect_firmware() {
	dd if=/dev/mtd0 of=/boot_backup.img
	strings /boot_backup.img > /boot_backup_strings.txt
	
	if grep -q "demo.bin" /boot_backup_strings.txt ; then # Cam v2 & Cam Pan
		msg "Camera is currently on Cam Pan v2 or Cam Pan stock firmware"
		current_profile="stock"
	
	elif grep -q "demo_wcv3.bin" /boot_backup_strings.txt ; then # Cam v3
		msg "Camera is currently on Cam v3 stock firmware"
		current_profile="stock"
	
	elif grep -q "recovery_wcpv2.bin" /boot_backup_strings.txt ; then # Cam Pan v2
		msg "Camera is currently on Cam Pan v2 stock firmware"
		current_profile="stock"
	
	elif grep -q "factory_0P3N1PC_kernel" /boot_backup_strings.txt ; then
		msg "Camera is currently on OpenIPC firmware"
		current_profile="openipc"
	
	else
		msg "Unable to detect current firmware" || return 1
	
	fi
}

function detect_profile() {
	if [[ "current_profile" == "openipc" ]]; then
		current_profile="openipc"
	elif [[ "current_profile" == "stock" ]] && [[ "$chip_family" == "t20" ]] ; then
		current_profile="stock_t20"
	elif [[ "current_profile" == "stock" ]] && [[ "$chip_family" == "t31" ]] ; then
		current_profile="stock_t31"
	else
		msg "Unable to select firmware profile" || return 1
	fi
}

init_detect() {
	detect_hardware
	detect_firmware || return 1
	detect_profile || return 1
}

init_detect || return 1
