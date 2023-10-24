#!/bin/sh



t31_stock_backup_partname_list="boot kernel rootfs app kback aback cfg para"
t31_stock_backup_dir_path="/sdcard/Wyze_factory_backup"
t31_stock_full_flash_filename="t31_stock_all.bin"

t31_stock_restore_partname_list="kernel rootfs app kback aback cfg para"
t31_stock_restore_dir_path="/sdcard/wz_flash-helper/restore/"
t31_stock_restore_stage_dir="/t31_stock_restore"

t31_stock_cfg_partmtdblock="/dev/mtdblock15"



function get_t31_stock_partmtd() {
# Description: Return mtd device of a given partition name on T31 cameras stock firmware
# Syntax: get_t31_stock_partmtd <partname>
	case "$1" in
		"boot")
			echo -n "/dev/mtd0" ;;
		"kernel")
			echo -n "/dev/mtd10" ;;
		"rootfs")
			echo -n "/dev/mtd11" ;;
		"app")
			echo -n "/dev/mtd12" ;;
		"kback")
			echo -n "/dev/mtd13" ;;
		"aback")
			echo -n "/dev/mtd14" ;;
		"cfg")
			echo -n "/dev/mtd15" ;;
		"para")
			echo -n "/dev/mtd16" ;;
	esac
}

function get_t31_stock_partimg() {
# Description: Return filename for the partition used for backup/restore of a given partition name on T31 stock firmware
# Syntax: get_t31_stock_partimg <partname>
	case "$1" in
		"boot")
			echo -n "t31_stock_boot.bin" ;;
		"kernel")
			echo -n "t31_stock_kernel.bin" ;;
		"rootfs")
			echo -n "t31_stock_rootfs.bin" ;;
		"app")
			echo -n "t31_stock_app.bin" ;;
		"kback")
			echo -n "t31_stock_kback.bin" ;;
		"aback")
			echo -n "t31_stock_aback.bin" ;;
		"cfg")
			echo -n "t31_stock_cfg.bin" ;;
		"para")
			echo -n "t31_stock_para.bin" ;;
	esac
}

function get_t31_stock_restore_opt_value() {
# Description: Return user option to decide if a given partition is restored or not on T31 stock firmware
# Syntax: get_t31_stock_restore_opt_value <partname>
	case "$1" in
		"kernel")
			echo -n "$t31_restore_kernel" ;;
		"rootfs")
			echo -n "$t31_restore_rootfs" ;;
		"app")
			echo -n "$t31_restore_app" ;;
		"kback")
			echo -n "$t31_restore_kback" ;;
		"aback")
			echo -n "$t31_restore_aback" ;;
		"cfg")
			echo -n "$t31_restore_cfg" ;;
		"para")
			echo -n "$t31_restore_para" ;;
	esac
}

