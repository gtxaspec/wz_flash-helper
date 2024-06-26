[Introduction](README.md) | [Setup](README_setup.md) | **Backup** | [Restore](README_restore.md) | [Switch firmware](README_switch_firmware.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md) | [Changelog](Changelog.md) | [Limitation](Limitation.md)

> **❗ WARNING:**
> - Backup your camera stock partitions first and copy them to a safe place in case you need them later for recovery.
> - Do not modify your stock partition backup images, especially the boot partition image, or else rolling back to the stock firmware may brick your camera.

## Overview

The Backup operation creates partition backup images for all partitions. Additionally, it creates an image for the entire flash and archive file(s) for writable partition(s). The partition backup images can be used to restore partitions or switch firmware.

## Guide

**Step 1:** [Setup](README_setup.md)

**Step 2:** Edit `general.conf` with:
```
backup_partitions="yes"
restore_partitions="no"
```

**Step 3:** Insert your SD card into your camera and power on.

**Step 4:** Wait for the program to finish backing up the partitions. After it is finished, then your camera will reboot.

**Step 5:** Check your SD card for the backup directory:

- For stock firmware: `wz_flash-helper/backup/stock/` and `Wyze_factory_backup/`
- For thingino firmware: `wz_flash-helper/backup/thingino/`

Under those directories, there are directories with 4-digit ID names where partition backup images are stored.

To know what backup ID was used for the most recent backup, check the `initramfs_serial.log` file.

## Notes

- The Backup operation automatically generates .sha256sum files for partition backup images and archives.
- During the Backup operation, the blue LED would be blinking every second.
- Typically the Backup operation takes about 30 seconds (excluding load time).
