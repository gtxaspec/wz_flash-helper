
[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | **Switch profile** | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md)


**❗ WARNING:**
- DO NOT DISCONNECT POWER when the switch profile operation is going on. Doing this would brick your camera.
- Switching to other profiles from OpenIPC is not supported yet. If you have switched to OpenIPC, you need to use SSH or serial connection to switch manually.
- Switching to wzmini profile is not supported yet (it is actually supported, but the firmware is still in early development stage)

-----

❓ **Q:** Hold on, are switch profile and switch firmware the same thing? - **A:** Not really, but if you are using existing profiles(stock, openipc and wzmini), they are the same.

## 📋 Index

Switch profile overview

[Switch to Stock profile](README_switch_profile_stock.md)

[Switch to OpenIPC profile](README_switch_profile_openipc.md)

[Switch to wzmini profile](README_switch_profile_wzmini.md) 

-----

**✅ Option: `switch_profile_with_all_partitions`**

With this option, you can decide if all partitions will be written by the switch profile operation.

When it is disabled, only the necessary partitions for a barely functional camera are written.

- For OpenIPC: `boot`, `kernel` and `rootfs` are written; `rootfs_data` would be formatted.
- For Stock T20: `boot`, `kernel`, `root`, `driver`, `appfs`, `config` and `para` are written; `backupa` would be formatted.
- For Stock T31: `boot`, `kernel`, `rootfs`, `app` and `cfg` are written; `kback` would be formatted.

When it is enabled, all partition images are required for the switch profile operation to start. This is only helpful when you need to write `rootfs_data` partition for OpenIPC.

On Stock firmware, some partitions, such as `aback`, `kback`, `backupa`, `backupd`, etc., don't need to be written because they don't contain any meaningful data as they are used by Stock firmware as stage partitions to install updates. You can disable this option to save time.

This option value has no effect when switching to the wzmini profile. All partitions are written anyway because writing the `configs` partition is required for your camera to be functional.

-----

## ℹ️ Notes

- For the switch profile operation to start, the `restore_partitions` option must be disabled, like in the above configurations. If both the  `restore_partitions` and `switch_profile` options are enabled, both operations would not be done.
- All partition images are verified with their .sha256sum files before the switch_profile operation starts. If one file fails the verification, no change will be made.
- During the switch profile operation, the red and blue LEDs would be blinking alternately.

