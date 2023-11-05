#!/bin/sh
#
# Description: This script contains variables of the current profile
#

## List of all partition names
current_profile_all_partname_list="boot env kernel rootfs rootfs_data"

## Where all partition images will be saved
current_profile_backup_path="/sdcard/wz_flash-helper/backup/openipc"

## Filename of the entire flash dump file
current_profile_backup_allparts_filename="openipc_${chip_group}_all.bin"

## List of partitions will be archived
current_profile_archive_partname_list="rootfs_data"

### Where partition images used to restore partitions are located
current_profile_restore_path="/sdcard/wz_flash-helper/restore/openipc"

## Same as "current_profile_all_partname_list" but without boot partition, the user can choose what partitions will be restored
current_profile_restore_partname_list="env kernel rootfs rootfs_data"

## Name of SD card kernel
current_profile_sdcard_kernel_name="factory_t20_0P3N1PC_kernel"
current_profile_sdcard_secondary_kernel_name="factory_t20_ZMC6tiIDQN"
