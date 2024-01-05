[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | **Restore** | [Switch firmware](README_switch_firmware.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md) | [Changelog](Changelog.md) | [Limitation](Limitation.md)

> **❗ WARNING:**
> - DO NOT DISCONNECT POWER when the restore operation is going on. This would soft brick your camera.

## Overview

The restore operation allows restoring one or more partitions using partition images. You can decide what partitions will be restored.

## Guide

**Step 1: [Setup](README_setup.md)**

**Step 2:** Place your partition restore images along with their .sha256sum files under the `wz_flash-helper/restore/[firmware]` directory on your SD card. They should have this format:

- `[firmware]_[SoC]_[partition name].bin` for partition restore images.
- `[firmware]_[SoC]_[partition name].bin.sha256sum` for their .sha256sum files.

Example for Stock restore images on t31x:

![Alt text](https://raw.githubusercontent.com/archandanime/wz_flash-helper/main/images/restore_01.png)

**Step 3:** Edit `[firmware].conf` under the `wz_flash-helper/restore/` directory on your SD card to select what partitions will be restored:

**Step 4:** Edit `general.conf` to enable the restore operation:
```
switch_firmware="no"
restore_partitions="yes"
```
**Step 5:** Insert your SD card into your camera and power on. Wait for the program to finish. After it is finished, your camera will reboot.

## Notes

- For the backup operation to start, the `switch_firmware` option must be disabled. If both the `restore_partitions` and `switch_firmware` options are enabled, the backup operation operation will fail.
- All partition restore images must come with their .sha256sum files for integrity verification.
- During the restore operation, the red LED would be blinking every second.
- Typically, the restore operation takes about 2 minutes (excluding load time).

## Restore the boot partition

> **❗ WARNING:** Doing this might brick your camera, only do when you know what you are doing.

To restore the `boot` partition, add this hidden option to `[firmware].conf` under the `wz_flash-helper/restore/[firmware]` directory:
```
hidden_option_restore_boot="yes"
```
