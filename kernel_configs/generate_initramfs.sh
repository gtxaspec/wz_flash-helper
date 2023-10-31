#!/bin/bash

cd /tmp
[ -f initramfs.cpio ] && rm initramfs.cpio
[ -d initramfs_root ] && rm -r initramfs_root

cp -r /git/wz_flash-helper/initramfs_skeleton initramfs_root

cd initramfs_root
mkdir -p {bin,dev,etc,lib,mnt,proc,root,sbin,sys,tmp}

mknod ./dev/console c 5 1
mknod ./dev/null c 1 3
mknod ./dev/tty0 c 4 0
mknod ./dev/tty1 c 4 1
mknod ./dev/tty2 c 4 2
mknod ./dev/tty3 c 4 3
mknod ./dev/tty4 c 4 4

find . |  cpio --create --format='newc' | gzip > /tmp/initramfs.cpio
