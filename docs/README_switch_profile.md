[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | **Switch profile** | [Other options](README_other_options.md) | [FAQs](README_FAQs.md_)

## How to switch between stock and OpenIPC profile


**IMPORTANT:** If your camera is T31, please find out if it is `T31a` or `T31x` to download the correct OpenIPC build. Using the wrong build would hard brick your camera.

First you need to have partition images at `(SD card)/wz_flash-helper/restore/(profile)`

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

After editing `general.conf`, download the correct build from OpenIPC website, rename it with format:
```
openipc_[Soc]_[partition name].bin
```

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
