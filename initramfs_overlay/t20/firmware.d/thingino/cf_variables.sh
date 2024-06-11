#!/bin/sh
#
# Description: This script contains variables for the current firmware
#

## List of all partition names
cf_all_partname_list="boot env ota"

## Where all partition images will be saved
cf_backup_path="/sdcard/wz_flash-helper/backup/thingino"

## Filename of the entire flash dump file
cf_backup_allparts_filename="thingino_${chip_group}_all.bin"

## List of partitions will be archived
cf_archive_partname_list=""

### Where partition images used to restore partitions are located
cf_restore_path="/sdcard/wz_flash-helper/restore/thingino"

## Same as "cf_all_partname_list" but without boot partition, the user can choose what partitions will be restored
cf_restore_partname_list="env ota"

## Name of SD card kernel
cf_sdcard_kernel_name="factory_t31_0P3N1PC_kernel"
cf_sdcard_secondary_kernel_name="factory_t31_ZMC6tiIDQN"
