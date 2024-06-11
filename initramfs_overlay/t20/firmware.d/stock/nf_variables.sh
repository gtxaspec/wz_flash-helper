#!/bin/sh
#
# Description: This script contains variables for the next firmware
#

## List of all partition names
nf_all_partname_list="boot kernel root driver appfs backupk backupd backupa config para"

## Where all partition images will be saved
## Same as cf_restore_path
nf_images_path="/sdcard/wz_flash-helper/restore/stock/"

## Name of SD card kernel
nf_sdcard_kernel_name="factory_ZMC6tiIDQN"

## Name of update flash image
nf_firmware_filename="stock_${chip_group}_firmware.bin"
