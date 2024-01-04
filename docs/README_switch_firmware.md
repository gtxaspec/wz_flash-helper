
[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | **Switch firmware** | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md) | [Changelog](Changelog.md) | [Limitation](Limitation.md)


**❗ WARNING:**
- DO NOT DISCONNECT POWER when the switch firmware operation is going on. Doing this would brick your camera.
- DO NOT share `initramfs.log` when you are switching to OpenIPC with the `setup_openipc_env.sh` script, this log file contains your Wi-Fi name and password.
- Switching to wzmini firmware is not supported yet (it is actually supported, but the firmware is still in early development stage).

-----

## 📋 Index

Switch firmware overview

[Switch to Stock firmware](README_switch_firmware_stock.md)

[Switch to OpenIPC firmware](README_switch_firmware_openipc.md)

[Switch to wzmini firmware](README_switch_firmware_wzmini.md) 

-----

**✅ Option: `switch_firmware_with_all_partitions`**

With this option, you can decide if all partitions will be written by the switch firmware operation.

When it is disabled, only the necessary partitions for a barely functional camera are written.

- For OpenIPC: `boot`, `kernel` and `rootfs` are written; `rootfs_data` would be formatted.
- For Stock T20: `boot`, `kernel`, `root`, `driver`, `appfs`, `config` and `para` are written; `backupa` would be formatted.
- For Stock T31: `boot`, `kernel`, `rootfs`, `app` and `cfg` are written; `kback` would be formatted.

When it is enabled, all partition images are required for the switch firmware operation to start. This is only helpful when you need to write `rootfs_data` partition for OpenIPC.

On Stock firmware, some partitions, such as `aback`, `kback`, `backupa`, `backupd`, etc., don't need to be written because they don't contain any meaningful data as they are used by Stock firmware as stage partitions to install updates. You can disable this option to save time.

This option value has no effect when switching to the wzmini firmware. All partitions are written anyway because writing the `configs` partition is required for your camera to be functional.

-----

## ℹ️ Notes

- For the switch firmware operation to start, the `restore_partitions` option must be disabled, like in the above configurations. If both the  `restore_partitions` and `switch_firmware` options are enabled, both operations would not be done.
- All partition images are verified with their .sha256sum files before the switch firmware operation starts. If one partiton image fails the verification, no change will be made.
- During the switch firmware operation, the red and blue LEDs would be blinking alternately.

