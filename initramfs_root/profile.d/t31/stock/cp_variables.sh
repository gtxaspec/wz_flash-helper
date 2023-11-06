#!/bin/sh
#
# Description: This script contains variables of the current profile
#

## List of all partition names
cp_all_partname_list="boot kernel rootfs app kback aback cfg para"

## Where all partition images will be saved
cp_backup_path="/sdcard/wz_flash-helper/backup/stock"
cp_backup_secondary_path="/sdcard/Wyze_factory_backup"

## Filename of the entire flash dump file
cp_backup_allparts_filename="stock_${chip_group}_all.bin"

## List of partitions will be archived
cp_archive_partname_list="cfg"

### Where partition images used to restore partitions are located
cp_restore_path="/sdcard/wz_flash-helper/restore/stock"

## Same as "cp_all_partname_list" but without boot partition, the user can choose what partitions will be restored
cp_restore_partname_list="kernel rootfs app kback aback cfg para"

## Name of SD card kernel
cp_sdcard_kernel_name="factory_t31_ZMC6tiIDQN"
