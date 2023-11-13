[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | **Restore** | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md)

**❗ WARNING:**
- DO NOT DISCONNECT POWER when the restore operation is going on. This would soft brick your camera.

-----

### 📖 Overview

The restore operations allows restoring one or more partitions using partition images. You can decide what partitions will be restored.

### 🛠️ Guide

**Step 1: [Setup](README_setup.md)**

**Step 2:** Place your partition restore images along with their .sha256sum files under the `wz_flash-helper/restore/[profile]` directory on your SD card. They should have this format:

- `[profile]_[SoC]_[partition name].bin` for partition restore images.
- `[profile]_[SoC]_[partition name].bin.sha256sum` for their .sha256sum files.

Example for Stock restore images on t31x:

![Alt text](https://raw.githubusercontent.com/archandanime/wz_flash-helper/main/images/restore_01.png)

**Step 3:** Edit `[profile].conf` under the `wz_flash-helper/restore/` directory on your SD card to select what partitions will be restored:

**Step 4:** Edit `general.conf` to enable the restore operation:
```
switch_profile="no"
restore_partitions="yes"
```
**Step 5:** Insert your SD card into your camera and power on. Wait till the program is finished and reboots.

### ℹ️ Notes
- There is no option to restore your boot partition to avoid accidentally corrupting it.
- For the backup operation to start, `switch_profile` option must be disabled, like the above configurations. If both the `restore_partitions` and `switch_profile` options are enabled, both operations will not be done.
- All partition restore images must come with their .sha256sum file for integrity verification.
- During the restore operation, the red LED would be blinking every second.
- Typically restore operation takes about 2 minutes (for reference, it takes 2 minutes and 15 seconds on Wyze Cam v3).
