#!/bin/sh
#
# Description: This script contains variables for the next firmware
#

## List of all partition names
nf_all_partname_list="boot env kernel rootfs rootfs_data"

## Where all partition images are saved
## Same as cf_restore_path
nf_images_path="/sdcard/wz_flash-helper/restore/openipc"

## Name of SD card kernel
nf_sdcard_kernel_name="factory_t31_0P3N1PC_kernel"
nf_sdcard_secondary_kernel_name="factory_t31_ZMC6tiIDQN"
