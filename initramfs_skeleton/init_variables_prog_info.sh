#!/bin/sh




prog_name="wz_flash-helper"
prog_version=$(cat /prog_ver.txt)

prog_dir="/sdcard/wz_flash-helper"
prog_config_file="/sdcard/wz_flash-helper/wz_flash-helper.conf"
prog_log_file="/sdcard/wz_flash-helper/wz_flash-helper.log"
prog_log_file_serial="/sdcard/wz_flash-helper/wz_flash-helper_serial.log"

concat_bootpart="/dev/mtd0"
concat_partmtd="/dev/mtd1"
