#!/bin/sh

source /variables_prog_info.sh

mountpoint -q /sdcard || mount -t vfat /dev/mmcblk0p1 /sdcard -o rw,umask=0000,dmask=0000
nano $prog_config_file
sync
