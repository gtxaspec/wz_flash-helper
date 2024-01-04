#!/bin/sh
#
# Description: This script contains variables for the current firmware
#

## List of all partition names
cf_all_partname_list="boot kernel root driver appfs backupk backupd backupa config para"

## Where all partition images will be saved
cf_backup_path="/sdcard/wz_flash-helper/backup/stock"
cf_backup_secondary_path="/sdcard/Wyze_factory_backup"

## Filename of the entire flash dump file
cf_backup_allparts_filename="stock_${chip_group}_all.bin"

## List of partitions will be archived
cf_archive_partname_list="config para"

### Where partition images used to restore partitions are located
cf_restore_path="/sdcard/wz_flash-helper/restore/stock/"

## Same as "cf_all_partname_list" but without boot partition, the user can choose what partitions will be restored
cf_restore_partname_list="kernel root driver appfs backupk backupd backupa config para"

## Name of SD card kernel
cf_sdcard_kernel_name="factory_ZMC6tiIDQN"
