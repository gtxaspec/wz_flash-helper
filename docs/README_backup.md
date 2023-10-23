[Introduction](README.md) | [Setup](README_setup.md) | **Backup** | [Restore](README_restore.md) | [Switch firmware](README_switch_fw.md) | [Other options](README_other_options.md)

## Backup partitions guide

1. [Setup](README_setup.md)
2. Edit the config file `wz_flash-helper.conf` with:
```
backup_partitions="yes"
restore_partitions="no"
```
3. Insert your SD card and power on your camera.
4. Wait for the camera to restart after backup operation is finished. 
5. Check your SD card, there should be a `wz_flash-helper/backup/stock` or `wz_flash-helper/backup/openipc` directory where backup of camera partitions are stored.

**WARNING:** Backup your stock partitions first and copy it to a safe place in case you need them for later recovery.

**Notes:**
- Backup operation will automatically generate md5sum files for backed up partition images.
- During backup operation, the blue LED would be blinking.