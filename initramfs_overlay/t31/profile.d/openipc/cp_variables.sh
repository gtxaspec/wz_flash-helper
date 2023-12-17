#!/bin/sh
#
# Description: This script contains variables for the current profile
#

## List of all partition names
cp_all_partname_list="boot env kernel rootfs rootfs_data"

## Where all partition images will be saved
cp_backup_path="/sdcard/wz_flash-helper/backup/openipc"

## Filename of the entire flash dump file
cp_backup_allparts_filename="openipc_${chip_group}_all.bin"

## List of partitions will be archived
cp_archive_partname_list="rootfs_data"

### Where partition images used to restore partitions are located
cp_restore_path="/sdcard/wz_flash-helper/restore/openipc"

## Same as "cp_all_partname_list" but without boot partition, the user can choose what partitions will be restored
cp_restore_partname_list="env kernel rootfs rootfs_data"

## Name of SD card kernel
cp_sdcard_kernel_name="factory_t31_0P3N1PC_kernel"
cp_sdcard_secondary_kernel_name="factory_t31_ZMC6tiIDQN"
