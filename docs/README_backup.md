[Introduction](README.md) | [Setup](README_setup.md) | **Backup** | [Restore](README_restore.md) | [Switch firmware](README_switch_firmware.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md) | [Changelog](Changelog.md) | [Limitation](Limitation.md)

**❗ WARNING:**

- Backup your camera Stock partitions first and copy them to a safe place in case you need them later for recovery.
- Do not modify your Stock partition backup images, especially the boot partition image, or else rolling back to the Stock firmware may brick your camera.

## Overview

The backup operation creates partition backup images for all partitions. Additionally, it creates an image for the entire flash and archive file(s) for writable partition(s). The partition backup images can be used later to restore partitions or for firmware switching.

## Guide

**Step 1:** [Setup](README_setup.md)

**Step 2:** Edit `general.conf` with:
```
backup_partitions="yes"
restore_partitions="no"
```

**Step 3:** Insert your SD card into your camera and power on.

**Step 4:** Wait for the program to finish. After it is finished, then camera will reboot.

**Step 5:** Check your SD card for the backup directory:

- For Stock: `wz_flash-helper/backup/stock` and `Wyze_factory_backup`
- For OpenIPC: `wz_flash-helper/backup/openipc`
- For wzmini: `wz_flash-helper/backup/wzmini`

Under those directories, there are directories with 4-digit ID names where partition backup images are stored.

To know what backup ID was used for the most recent backup, check the `initramfs_serial.log` file.

## Notes

- The backup operation automatically generates .sha256sum files for partition backup images and archives.
- During the backup operation, the blue LED would be blinking every second.
- Typically the backup operation takes about 30 seconds (excluding load time).
