#!/bin/sh
#
# Description: This script contains variables for the current firmware
#

## List of all partition names
cf_all_partname_list="boot env kernel rootfs rootfs_data"

## Where all partition images will be saved
cf_backup_path="/sdcard/wz_flash-helper/backup/openipc"

## Filename of the entire flash dump file
cf_backup_allparts_filename="openipc_${chip_group}_all.bin"

## List of partitions will be archived
cf_archive_partname_list="rootfs_data"

### Where partition images used to restore partitions are located
cf_restore_path="/sdcard/wz_flash-helper/restore/openipc"

## Same as "cf_all_partname_list" but without boot partition, the user can choose what partitions will be restored
cf_restore_partname_list="env kernel rootfs rootfs_data"

## Name of SD card kernel
cf_sdcard_kernel_name="factory_t31_0P3N1PC_kernel"
cf_sdcard_secondary_kernel_name="factory_t31_ZMC6tiIDQN"
