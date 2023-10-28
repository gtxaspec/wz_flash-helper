#!/bin/sh
#
# Description: This script contains variables of the next firmware profile
#

## List of supported chip family
next_profile_chip_family="t31"

## List of all partition names
next_profile_all_partname_list="boot kernel rootfs app kback aback cfg para"

## Where all partition images will be saved
## Same as current_profile_backup_path
next_profile_images_path="/sdcard/wz_flash-helper/restore/stock"

