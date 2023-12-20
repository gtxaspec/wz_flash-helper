#!/bin/sh

echo -n "Mounting SD card... "
mountpoint -q /sdcard || mount -t vfat /dev/mmcblk0p1 /sdcard -o rw,umask=0000,dmask=0000 && echo "done" || echo "failed"
echo
