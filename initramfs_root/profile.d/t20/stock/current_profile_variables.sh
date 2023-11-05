#!/bin/sh
#
# Description: This script contains variables of the current profile
#

## List of all partition names
current_profile_all_partname_list="boot kernel root driver appfs backupk backupd backupa config para"

## Where all partition images will be saved
current_profile_backup_path="/sdcard/wz_flash-helper/backup/stock"
current_profile_backup_secondary_path="/sdcard/Wyze_factory_backup"

## Filename of the entire flash dump
current_profile_backup_allparts_filename="stock_${chip_group}_all.bin"

## List of partitions will be archived
current_profile_archive_partname_list="config para"

### Where partition images used to restore partitions are located
current_profile_restore_path="/sdcard/wz_flash-helper/restore/stock/"

## Same as "current_profile_all_partname_list" but without boot partition, the user can choose what partitions will be restored
current_profile_restore_partname_list="kernel root driver appfs backupk backupd backupa config para"

## Name of SD card boot image
current_profile_sdcard_kernelimg_name="factory_ZMC6tiIDQN"
