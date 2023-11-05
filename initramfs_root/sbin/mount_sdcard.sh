#!/bin/sh

echo -n "Mounting SD card... "
mount -t vfat /dev/mmcblk0p1 /sdcard -o rw,umask=0000,dmask=0000 && echo "ok" || echo "failed"
echo
