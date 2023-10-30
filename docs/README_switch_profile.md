[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | **Switch profile** | [Other options](README_other_options.md) | [FAQs](README_FAQs.md_)

## How to switch between stock and OpenIPC profile


**Step 1: Preparation**
You need to have partition images at `(SD card)/wz_flash-helper/restore/(profile)`. They should have have this format: `(profile)_(SoC type)_(partition name).bin`, with `SoC type` is `t20`, `t31a` or `t31x`(eg. stock_t31x_kernel.bin).
To switch from stock to OpenIPC profile, download the correct build from OpenIPC website, rename it with the above format.
**IMPORTANT:** If your camera is T31, please find out if it is `T31a` or `T31x` to download the correct OpenIPC build. Using the wrong build would hard brick your camera.

**Step 2: Edit configuration file**
To switch from stock to OpenIPC profile, edit `general.conf` with:
```
restore_partitions="no"
switch_profile="yes"
next_profile="openipc"
```

To switch from OpenIPC to stock profile, edit `general.conf` with:
```
restore_partitions="no"
switch_profile="no"
next_profile="stock"
```

**Step 3: Decide switch profile with all partitions**
With the option `switch_profile_with_all_partitions=` in `general.conf`, you can decide when switching profile, all partition images will be used or not.
With it enabled:
- Switching from stock to OpenIPC needs partition images of all partitions including `rootfs_data`, if you don't have `rootfs_data` image, leave it disabled.
- Switching from OpenIPC also needs partition images of all partitions.

When switching from OpenIPC to stock, some partitions such as `aback`, `kback`, `backupa`, `backupd`, etc. they don't need to be restored because they don't contain any anything as they are used by stock update. You can disable this option to save some time.






**WARNING:** DO NOT DISCONNECT POWER when switch profile operation is going on. This would brick your camera.

Conditions for switch profile operation to work:
1. All partition images of the profile types that you want to switch to must present in either:
- `(SD card)/wz_flash-helper/restore/stock` or
- `(SD card)/wz_flash-helper/restore/openipc`
2. All partition images must come with their md5sum file in `<partition image>.md5sum` format.


**Note:**
- `restore_partitions` option must be disabled like the above configurations. If both `restore_partitions` and `switch_profile`are enabled, both operations would not be executed.
- All partition images are verified with their md5sum files before switch_profile operation starts, no need to worry a currupted partition image.
- During switch profile operation, both the blue LED and the red LED would be blinking.
