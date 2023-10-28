#!/bin/sh
#
# Description: This script contains variables of the current firmware profile
#

## List of all partition names
current_profile_all_partname_list="[boot] [rootfs] [config] [para]"

## Where all partition images will be saved
current_profile_backup_path="[/sdcard/backup_dir]"

## Filename of the entire flash dump
current_profile_backup_allparts_filename="[FW_PROFILE_entire_flash.bin]"

## List of partitions will be archived
current_profile_archive_partname_list="[config] [para]"

### Where partition images used to restore partitions are located
current_profile_restore_path="[/sdcard/restore_dir]"

## Same as "current_profile_all_partname_list" but without boot partition, the user can choose what partitions will be restored
current_profile_restore_partname_list="[rootfs] [config] [para]"

## Name of SD card boot image
current_profile_sdcard_boot_img_name="[SDcard_boot.img]"
