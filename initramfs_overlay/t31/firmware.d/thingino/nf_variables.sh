#!/bin/sh
#
# Description: This script contains variables for the next firmware
#

## List of all partition names
nf_all_partname_list="boot env ota"

## Where all partition images are saved
## Same as cf_restore_path
nf_images_path="/sdcard/wz_flash-helper/restore/thingino"

## Name of SD card kernel
nf_sdcard_kernel_name="factory_t31_0P3N1PC_kernel"
nf_sdcard_secondary_kernel_name="factory_t31_ZMC6tiIDQN"

## Name of update flash image
nf_firmware_filename="thingino_${chip_group}_firmware.bin"
