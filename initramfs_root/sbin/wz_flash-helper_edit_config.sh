#!/bin/sh

source /init_variables_prog_info.sh

! mountpoint -q /sdcard && mount_sdcard.sh
nano $prog_config_file
sync
