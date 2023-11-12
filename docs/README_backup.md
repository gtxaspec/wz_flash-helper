[Introduction](README.md) | [Setup](README_setup.md) | **Backup** | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md)



**❗ WARNING:**
- Backup your Stock partitions first and copy them to a safe place in case you need them for later recovery.
- Do not modify your Stock partition backup images, especially the boot partition image, or else rolling back to the Stock profile may brick your camera.

-----

### Backup Stock partitions
**Step 1:** [Setup](README_setup.md)

**Step 2:** Edit `general.conf` with:
```
backup_partitions="yes"
restore_partitions="no"
```

**Step 3:** Insert your SD card into your camera and power on.

**Step 4:** Wait for the camera to restart after the backup operation is finished.

**Step 5:** Check your SD card; there should be `Wyze_factory_backup` and `wz_flash-helper/backup/stock` directories. Under those directories, there are directories with 4-digit ID names where partition backup images are stored.

To know what backup ID was used for the most recent backup, check the `initramfs_serial.log` file.

### Backup OpenIPC partitions
Similar to Stock partitions, OpenIPC partitions can be backed up with the above steps. OpenIPC partition backup images would be under the `wz_flash-helper/backup/openipc` directory.

### Backup wzmini partitions
Similar to Stock partitions, wzmini partitions can be backed up with the above steps. wzmini partition backup images would be under the `wz_flash-helper/backup/wzmini` directory.

-----

**ℹ️ Notes:**
- Backup operation will automatically generate .sha256sum files for partition backup images.
- During the backup operation, the blue LED would be blinking every second.
- Typically backup operation takes about 30 seconds(for reference, it takes 25 seconds on Wyze Cam v3).
