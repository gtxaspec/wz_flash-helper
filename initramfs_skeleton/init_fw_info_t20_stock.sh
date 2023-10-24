#!/bin/sh




t20_stock_backup_partname_list="boot kernel root driver appfs backupk backupd backupa config para"
t20_stock_backup_dir_path="/sdcard/Wyze_factory_backup"
t20_stock_full_flash_filename="t20_stock_all.bin"

t20_stock_restore_partname_list="kernel root driver appfs backupk backupd backupa config para"
t20_stock_restore_dir_path="/sdcard/wz_flash-helper/restore/"
t20_stock_restore_stage_dir="/t20_stock_restore"

t20_stock_config_partmtdblock="/dev/mtdblock8"
t20_stock_para_partmtdblock="/dev/mtdblock9"



function get_t20_stock_partmtd() {
# Description: Return mtd device of a given partition name on T20 cameras stock firmware
# Syntax: get_t20_stock_partmtd <partname>
	case "$1" in
		"boot")
			echo -n "/dev/mtd0" ;;
		"kernel")
			echo -n "/dev/mtd1" ;;
		"root")
			echo -n "/dev/mtd2" ;;
		"driver")
			echo -n "/dev/mtd3" ;;
		"appfs")
			echo -n "/dev/mtd4" ;;
		"backupk")
			echo -n "/dev/mtd5" ;;
		"backupd")
			echo -n "/dev/mtd6" ;;
		"backupa")
			echo -n "/dev/mtd7" ;;
		"config")
			echo -n "/dev/mtd8" ;;
		"para")
			echo -n "/dev/mtd9" ;;
	esac
}

function get_t20_stock_partimg() {
# Description: Return filename for the partition used for backup/restore of a given partition name on T20 stock firmware
# Syntax: get_t20_stock_partimg <partname>
	case "$1" in
		"boot")
			echo -n "t20_stock_boot.bin" ;;
		"kernel")
			echo -n "t20_stock_kernel.bin" ;;
		"root")
			echo -n "t20_stock_root.bin" ;;
		"driver")
			echo -n "t20_stock_driver.bin" ;;
		"appfs")
			echo -n "t20_stock_appfs.bin" ;;
		"backupk")
			echo -n "t20_stock_backupk.bin" ;;
		"backupd")
			echo -n "t20_stock_backupd.bin" ;;
		"backupa")
			echo -n "t20_stock_backupa.bin" ;;
		"config")
			echo -n "t20_stock_config.bin" ;;
		"para")
			echo -n "t20_stock_para.bin" ;;
	esac
}

function get_t20_stock_restore_opt_value() {
# Description: Return user option to decide if a given partition is restored or not on T20 stock firmware
# Syntax: get_t20_stock_restore_opt_value <partname>
	case "$1" in
		"kernel")
			echo -n "$t20_restore_kernel" ;;
		"root")
			echo -n "$t20_restore_root" ;;
		"driver")
			echo -n "$t20_restore_driver" ;;
		"appfs")
			echo -n "$t20_restore_appfs" ;;
		"backupk")
			echo -n "$t20_restore_backupk" ;;
		"backupd")
			echo -n "$t20_restore_backupd" ;;
		"backupa")
			echo -n "$t20_restore_backupa" ;;
		"config")
			echo -n "$t20_restore_config" ;;
		"para")
			echo -n "$t20_restore_para" ;;
	esac
}

