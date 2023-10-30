[Introduction](README.md) | [Setup](README_setup.md) | **Backup** | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | [FAQs](README_FAQs.md)

## Backup guide


### Backup stock partitions
1. [Setup](README_setup.md)
2. Edit the config file `general.conf` with:
```
backup_partitions="yes"
restore_partitions="no"
```
3. Insert your SD card and power on your camera.
4. Wait for the camera to restart after backup operation is finished.
5. Check your SD card, there should be a `Wyze_factory_backup` and `wz_flash-helper/backup/stock` directores where two copies of stock partitions backup are stored.


### Backup OpenIPC partitions
Like with stock partitions, OpenIPC partitions can also be backed up with the above steps. Backup of OpenIPC partitions is at `wz_flash-helper/backup/openipc`.


**WARNING:**
- Backup your stock partitions first and copy it to a safe place in case you need them for later recovery.
- Do not modify your stock partitions backup, specially boot partition image. Switching from OpenIPC back to stock profile may brick your camera if you do that.

-----
**Notes:**
- Backup operation will automatically generate md5sum files for partitions backup files.
- During backup operation, the blue LED would be blinking every second.
- Typically backup operation takes about 30 seconds(for reference it takes 25 seconds on Wyze Cam v3)
