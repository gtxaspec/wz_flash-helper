
[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | **Switch firmware** | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md) | [Changelog](Changelog.md) | [Limitation](Limitation.md)

> **❗ WARNING:**
> - DO NOT DISCONNECT POWER when the Switch firmware operation is going on. Doing this would brick your camera.
> - DO NOT share `initramfs.log` when you are switching to OpenIPC with the `setup_openipc_env.sh` script, this log file contains your Wi-Fi name and password.
> - Currently Wi-Fi and SD card don't work on OpenIPC firmware yet until they are fixed upstream

## Overview

The Switch firmware operation allow your camera to switch from one firmware to another.

## Index

Switch firmware overview

[Switch to stock firmware](README_switch_firmware_stock.md)

[Switch to OpenIPC firmware](README_switch_firmware_openipc.md)

**✅ Option: `switch_firmware_with_all_partitions`**

With this option, you can decide if all partitions will be written by the Switch firmware operation.

- When it is disabled, only partition images for some necessary partitions for a barely functional camera are required. Other partitions are either formatted, erased or left alone. 
- When it is enabled, partition images for all partitions are required.

On stock firmware: Some partitions (such as `aback`, `kback`, `backupa`, `backupd`, etc. on T31 cameras) don't need to be written because they don't contain any meaningful data as they are used by stock firmware as stage partitions to install updates. You should disable this option to save time.

On OpenIPC firmware: If you want to have a fresh OpenIPC installation, leave it disabled. If you want to write `env` and `rootfs_data` partitions, you can enable it.

## Notes

- For the Switch firmware operation to start, the `restore_partitions` option must be disabled. If both the `restore_partitions` and `switch_firmware` options are enabled, the `switch_firmware` operation will fail.
- All partition images are verified with their .sha256sum files before the Switch firmware operation starts. If one partiton image fails the verification, no change will be made.
- During the Switch firmware operation, the red and blue LEDs would be blinking alternately.
