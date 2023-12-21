#!/bin/sh

echo -n "Umounting SD card... "
if mountpoint -q /sdcard ; then
	umount /sdcard && echo "done"
else
	echo "already umounted"
fi

echo
