#!/bin/sh
#
# PART: Partition name
# START: Partition start address
# END: Partition end address
# SIZE: Partition size(in 1k block)
# MTD MAPPING: MTD mapping by the kernel for partitions with size and offset so they can be read/written correctly
# MTD DEVICE: MTD device name that has been mapped by the kernel and can be performed read/write operations from user space
#
# Used partition names are the as mtdparts parameter on the kernels
#
#---------- T20 stock ----------
#PART     SIZE(dec)  START(dec)  START(hex)     MTD MAPPING               MTD DEVICE
#boot     256        0           0x0            256K@0(boot)              /dev/mtd0
#kernel   2048       256         0x40000        2048K@256K(t20_kernel)    /dev/mtd1
#root     3392       2304        0x240000       3392K@2304K(t20_root)     /dev/mtd2
#driver   640        5696        0x590000       640K@5696K(t20_driver)    /dev/mtd3
#appfs    4736       6336        0x630000       4736K@6336K(t20_apps)     /dev/mtd4
#backupk  2048       11072       0xad0000       2048K@11072K(t20_backupk) /dev/mtd5
#backupd  640        13120       0xcd0000       640K@13120K(t20_backupd)  /dev/mtd6
#backupa  2048       13760       0xd70000       2048K@13760K(t20_backupa) /dev/mtd7
#config   256        15808       0xf70000       256K@15808K(t20_config)   /dev/mtd8
#para     256        16064       0xfb0000       256K@16064K(t20_para)     /dev/mtd9
#
#---------- T31 stock ----------
#PART    SIZE(dec)  START(dec)  START(hex)     MTD MAPPING                MTD DEVICE
#boot    256        0           0x0            256K@0(boot)               /dev/mtd0
#kernel  1984       256         0x40000        1984K@256K(t31_kernel)     /dev/mtd10
#rootfs  3904       2240        0x230000       3904K@2240K(t31_rootfs)    /dev/mtd11
#app     3904       6144        0x600000       3904K@6144K(t31_app)       /dev/mtd12
#kback   1984       10048       0x9d0000       1984K@10048K(t31_kback)    /dev/mtd13
#aback   3904       12032       0xbc0000       3904K@12032K(t31_aback)    /dev/mtd14
#cfg     384        15936       0xf90000       384K@15936K(t31_cfg)       /dev/mtd15
#para    64         16320       0xff0000       64K@16320K(t31_para)       /dev/mtd16
#
#---------- T20 and T31 OpenIPC ----------
#PART         SIZE(dec)  START(dec)  START(hex) MTD MAPPING                       MTD DEVICE
#boot         256        0           0x0        256K@0(boot)                      /dev/mtd0
#env          64         256         0x40000    64K@256K(openipc_env)             /dev/mtd17
#kernel       3072       320         0x50000    3072K@320K(openipc_kernel)        /dev/mtd18
#rootfs       10240      3392        0x350000   10240K@3392K(openipc_rootfs)      /dev/mtd19
#rootfs-data  2752       13632       0xd50000   2752K@13632K(openipc_rootfs-data) /dev/mtd20
#
#Full flash mapping                            2752K@13632K,16384k@0(all)         /dev/mtd21
#
# MTD mapping with kernel commandline:
# CONFIG_CMDLINE="console=ttyS1,115200n8 mem=100M@0x0 rmem=28M@0x5000000 rdinit=/init mtdparts=jz_sfc:256K@0(boot),2048K@256K(t20_kernel),3392K@2304K(t20_root),640K@5696K(t20_driver),4736K@6336K(t20_apps),2048K@11072K(t20_backupk),640K@13120K(t20_backupd),2048K@13760K(t20_backupa),256K@15808K(t20_config),256K@16064K(t20_parcaa),1984K@256K(t31_kernel),3904K@2240K(t31_rootfs),3904K@6144K(t31_app),1984K@10048K(t31_kback),3904K@12032K(t31_aback),384K@15936K(t31_cfg),64K@16320K(t31_para),64K@256K(openipc_env),3072K@320K(openipc_kernel),10240K@3392K(openipc_rootfs),2752K@13632K(openipc_rootfs-data),16384k@0(all)"
#
#

function get_t20_stock_partmtd() {
# Description: Return MTD device of a given partition name on T20 cameras stock firmware
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

function get_t31_stock_partmtd() {
# Description: Return MTD device of a given partition name on T31 cameras stock firmware
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

function get_openipc_partmtd() {
# Description: Return MTD device of a given partition name on OpenIPC firmware
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
		"rootfs-data")
			echo -n "/dev/mtd20" ;;
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

function get_t31_stock_partimg() {
# Description: Return filename for the partition used for backup/restore of a given partition name on T31 stock firmware
# Syntax: get_t31_stock_partimg <partname>
	case "$1" in
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
		"rootfs-data")
			echo -n "openipc_rootfs-data.bin" ;;
	esac
}

function get_t20_stock_restore_opt_value() {
# Description: Return user option to decide if a given partition is restored or not on T20 stock firmware
# Syntax: get_t20_stock_restore_opt_value <partname>
	case "$1" in
		"boot")
			echo -n "$t20_restore_boot" ;;
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

function get_openipc_restore_opt_value() {
# Description: Return user option to decide if a given partition is restored or not on OpenIPC firmware
# Syntax: get_openipc_restore_opt_value <partname>
	case "$1" in
		"boot")
			echo -n "$openipc_restore_boot" ;;
		"env")
			echo -n "$openipc_restore_env" ;;
		"kernel")
			echo -n "$openipc_restore_kernel" ;;
		"rootfs")
			echo -n "$openipc_restore_rootfs" ;;
		"rootfs-data")
			echo -n "$openipc_restore_rootfs_data" ;;
	esac
}

