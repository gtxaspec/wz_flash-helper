[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | **Restore** | [Switch firmware](README_switch_fw.md) | [Other options](README_boot_img_next_boot.md)

## Restore partitions guide

1. [Setup](README_setup.md)
2. Edit `wz_flash-helper.conf` to select what partitions will be restored:
- If your camera is T20 on stock firmware, edit options start with `t20_restore_`
- If your camera is T31 on stock firmware, edit options start with `t31_restore_`
- If your camera is on OpenIPC firmware, edit options start with `openipc_restore_`
3. Edit `wz_flash-helper.conf` to enable restore operation:
```
switch_fw="no"
restore_partitions="yes"
```
4. Insert your SD card into your camera and reboot.


**Note:**
- Flash tool automatically detect camera SoC type and firmware type to use the correct options.
- `switch_fw` option must be disabled like the above configurations. If both `restore_partitions` and `switch_fw`are enabled, both operations would not be executed.
- All partition images must come with their md5sum file in <partition image>.md5sum
- During restore operation, the red LED would be blinking.
