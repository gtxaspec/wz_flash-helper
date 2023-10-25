[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | **Restore** | [Switch firmware](README_switch_fw.md) | [Other options](README_other_options.md)

## Restore partitions guide

1. [Setup](README_setup.md)
2. Place your partition restore images at `(SD card)/wz_flash-helper/restore/`
3. Edit `wz_flash-helper.conf` to select what partitions will be restored:
- If your camera is T20 on stock firmware, edit options start with `t20_restore_`
- If your camera is T31 on stock firmware, edit options start with `t31_restore_`
- If your camera is on OpenIPC firmware, edit options start with `openipc_restore_`
4. Edit `wz_flash-helper.conf` to enable restore operation:
```
switch_fw="no"
restore_partitions="yes"
```
5. Depends on what firmware your camera is running, with `wz_flash-helper.conf` with:
```
restore_fw_type="stock"
```
or
```
restore_fw_type="openipc"
```
6. Insert your SD card into your camera and reboot.


**Note:**
- Be careful not to restore wrong firmware(eg. Restore OpenIPC partitions on a camera running stock), though this does not brick your camera.
- There is no option to restore your boot partition to avoid accidentally corrupting it.
- `switch_fw` option must be disabled like the above configurations. If both `restore_partitions` and `switch_fw`are enabled, both operations will not be executed.
- All partition restore images must come with their md5sum file in `<partition image>.md5sum` format
- During restore operation, the red LED would be blinking every second.
- Typically restore operation takes about 2 minutes(for reference it takes 2 minutes 15 seconds on Wyze Cam v3)

