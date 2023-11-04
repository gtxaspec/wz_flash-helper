#!/bin/sh

echo -n "Mounting SD card... "
mkdir -p /sdcard
mount -t vfat /dev/mmcblk0p1 /sdcard -o rw,umask=0000,dmask=0000 && echo "succeeded" || echo "failed"
