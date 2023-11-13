[Introduction](README.md) | [Setup](README_setup.md) | **Backup** | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md)



**❗ WARNING:**
- Backup your Stock partitions first and copy them to a safe place in case you need them for later recovery.
- Do not modify your Stock partition backup images, especially the boot partition image, or else rolling back to the Stock profile may brick your camera.

-----

### 📖 Overview

The backup operation creates partition backup images for all partitions and the entire flash. It also creates and archive file(s) for writable partition(s). The partition backup images can be later used to restored partitions or for profile switching.

### 🛠️ Guide

**Step 1:** [Setup](README_setup.md)

**Step 2:** Edit `general.conf` with:
```
backup_partitions="yes"
restore_partitions="no"
```

**Step 3:** Insert your SD card into your camera and power on.

**Step 4:** Wait for the camera to restart after the backup operation is finished.

**Step 5:** Check your SD card for backup directory:

- For Stock: `wz_flash-helper/backup/stock` and `Wyze_factory_backup`
- For OpenIPC: `wz_flash-helper/backup/openipc`
- For wzmini: `wz_flash-helper/backup/wzmini`

Under those directories, there are directories with 4-digit ID names where partition backup images are stored.

To know what backup ID was used for the most recent backup, check the `initramfs_serial.log` file.

### ℹ️ Notes
- Backup operation automatically generates .sha256sum files for partition backup images and archives.
- During the backup operation, the blue LED would be blinking every second.
- Typically backup operation takes about 30 seconds(for reference, it takes 25 seconds on Wyze Cam v3).
