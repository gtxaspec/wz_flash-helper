#!/bin/sh

function detect_chip_and_fw() {
# Description: Detect chip family and current firmware to run later operations correctly
	chip_name=$(ipcinfo-mips32 --chip-name)
	chip_family=$(ipcinfo-mips32 --family)
	msg "Detected chip name: $chip_name, chip family: $chip_family"
	
	dd if=$boot_partmtd of=$boot_part_backup
	strings $boot_part_backup > /boot_partimg_strings
	
	if grep -q "demo.bin" /boot_backup_strings ; then # Cam v2 & Cam Pan
		msg "Camera is currently on Cam Pan v2 or Cam Pan stock firmware"
		current_fw_type="stock"
	
	elif grep -q "demo_wcv3.bin" /boot_backup_strings ; then # Cam v3
		msg "Camera is currently on Cam v3 stock firmware"
		current_fw_type="stock"
	
	elif grep -q "recovery_wcpv2.bin" /boot_backup_strings ; then # Cam Pan v2
		msg "Camera is currently on Cam Pan v2 stock firmware"
		current_fw_type="stock"
	
	elif grep -q "factory_0P3N1PC_kernel" /boot_backup_strings ; then
		msg "Camera is currently on OpenIPC firmware"
		current_fw_type="openipc"
	
	else
		{ msg "Can not detect current firmware type" ; exit_init ; }
	fi
	
	rm /boot_backup_strings
}
