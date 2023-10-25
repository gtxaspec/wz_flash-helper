#!/bin/sh




openipc_backup_dir_path="/sdcard/wz_flash-helper/backup/openipc"
openipc_backup_partname_list="boot env kernel rootfs rootfs_data"
openipc_backup_full_flash_filename="openipc_all.bin"

openipc_restore_partname_list="env kernel rootfs rootfs_data"
openipc_restore_dir_path="/sdcard/wz_flash-helper/restore/openipc"

openipc_switch_fw_write_partname_list="boot kernel rootfs"
openipc_switch_fw_erase_partname_list="env rootfs_data"



function get_openipc_partmtd() {
# Description: Return mtd device of a given partition name on OpenIPC firmware
# Syntax: get_openipc_partmtd <partname>
	case "$1" in
		"boot")
			echo -n "/dev/mtd0" ;;
		"env")
			echo -n "/dev/mtd17" ;;
		"kernel")
			echo -n "/dev/mtd18" ;;
		"rootfs")
			echo -n "/dev/mtd19" ;;
		"rootfs_data")
			echo -n "/dev/mtd20" ;;
	esac
}

function get_openipc_partimg() {
# Description: Return filename for the partition used for backup/restore of a given partition name on OpenIPC firmware
# Syntax: get_openipc_partimg <partname>
	case "$1" in
		"boot")
			echo -n "openipc_boot.bin" ;;
		"env")
			echo -n "openipc_env.bin" ;;
		"kernel")
			echo -n "openipc_kernel.bin" ;;
		"rootfs")
			echo -n "openipc_rootfs.bin" ;;
		"rootfs_data")
			echo -n "openipc_rootfs_data.bin" ;;
	esac
}

function get_openipc_restore_opt_value() {
# Description: Return user option to decide if a given partition is restored or not on OpenIPC firmware
# Syntax: get_openipc_restore_opt_value <partname>
	case "$1" in
		"env")
			echo -n "$openipc_restore_env" ;;
		"kernel")
			echo -n "$openipc_restore_kernel" ;;
		"rootfs")
			echo -n "$openipc_restore_rootfs" ;;
		"rootfs_data")
			echo -n "$openipc_restore_rootfs_data" ;;
	esac
}

