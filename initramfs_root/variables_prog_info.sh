#!/bin/sh
#
# Program variables to be sourced by the init script


prog_name="wz_flash-helper"

prog_dir="/sdcard/wz_flash-helper"
prog_config_file="$prog_dir/general.conf"
prog_log_file="$prog_dir/initramfs.log"
prog_log_file_serial="$prog_dir/initramfs_serial.log"

boot_partmtd="/dev/mtd0"
all_partmtd="/dev/mtd1"
