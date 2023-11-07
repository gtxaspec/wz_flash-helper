
[Introduction](README.md) | [Setup](README_setup.md) | **Backup** | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | [Build](README_build.md) | [FAQs](README_FAQs.md)



## Backup guide

**WARNING:**
- Backup your stock partitions first and copy it to a safe place in case you need them for later recovery.
- Do not modify your stock partitions backup, specially boot partition image. Switching from OpenIPC back to stock profile may brick your camera if you do that.


### Backup stock partitions
**Step 1:** [Setup](README_setup.md)

**Step 2:** Edit the config file `general.conf` with:
```
backup_partitions="yes"
restore_partitions="no"
```

**Step 3:** Insert your SD card and power on your camera.

**Step 4:** Wait for the camera to restart after backup operation is finished.

**Step 5:** Check your SD card, there should be a `Wyze_factory_backup` and `wz_flash-helper/backup/stock`directories. Under those 2 directories, there are directories with 4-digit ID where partition images backup are keep. To know what ID was used for the most recent backup, check `initramfs.log` file.


### Backup OpenIPC partitions
Like with stock partitions, OpenIPC partitions can also be backed up with the above steps. Backup of OpenIPC partitions is at `wz_flash-helper/backup/openipc`.


-----
**Notes:**
- Backup operation will automatically generate sha256sum files for backup partitions images.
- During backup operation, the blue LED would be blinking every second.
- Typically backup operation takes about 30 seconds(for reference it takes 25 seconds on Wyze Cam v3)

