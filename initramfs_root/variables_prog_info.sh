#!/bin/sh
#
# Description: Program varables to be sourced by init script
#

prog_name="wz_flash-helper"

prog_dir="/sdcard/wz_flash-helper"
prog_config_file="/sdcard/wz_flash-helper/general.conf"
prog_restore_config_file="/sdcard/wz_flash-helper/restore/$current_profile.conf"
prog_log_file="/sdcard/wz_flash-helper/initramfs.log"
prog_log_file_serial="/sdcard/wz_flash-helper/initramfs_serial.log"

boot_partmtd="/dev/mtd0"
all_partmtd="/dev/mtd1"
