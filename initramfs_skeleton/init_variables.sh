#!/bin/sh

flasher_tool_name="wz_flash-helper"

config_file="/sdcard/wz_flash-helper/wz_flash-helper.conf"
log_file="/sdcard/wz_flash-helper/wz_flash-helper.log"
log_file_fallback="/sdcard/wz_flash-helper_no-config-error.log"

## Backup directories
stock_backup_dir_path="/sdcard/Wyze_factory_backup"
openipc_backup_dir_path="/sdcard/wz_flash-helper/backup/openipc"

## Restore directories
stock_restore_dir_path="/sdcard/wz_flash-helper/restore/stock"
openipc_restore_dir_path="/sdcard/wz_flash-helper/restore/openipc"

## Switch_fw directories
stock_switch_fw_dir_path="/sdcard/wz_flash-helper/switch_fw/stock"
openipc_switch_fw_dir_path="/sdcard/wz_flash-helper/switch_fw/openipc"

## List of partitions for T20, T31, OpenIPC firmware
t20_stock_partname_list="boot kernel root driver appfs backupk backupd backupa config para"
t31_stock_partname_list="boot kernel rootfs app kback aback config para"
openipc_partname_list="boot env kernel rootfs rootfs-data"

## Names of full flash dump file
t20_stock_full_flash_filename="t20_stock_all.bin"
t31_stock_full_flash_filename="t31_stock_all.bin"
openipc_full_flash_filename="openipc_all.bin"
