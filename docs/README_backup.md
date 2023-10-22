[Introduction](README.md) | [Setup](README_setup.md) | **Backup** | [Restore](README_restore.md) | [Switch firmware](README_switch_fw.md) | [Other options](README_boot_img_next_boot.md)

## Backup partitions guide

0. [Setup](README_setup.md)
1. Edit the config file `wz_flash-helper.conf` with:
```
dry_run="yes"
backup_partitions="yes"
restore_partitions="no"
restore_fw_type="stock"
custom_script=""
```
3. Insert your SD card and power on your camera.
4. Wait for the camera to restart after wcv3_flasher-helper finishes its operations. Then turn the off camera, remove your SD card, and check `wz_flash-helper.log` on your SD card to see if everything looks fine and there is no error.
5. Edit `wz_flash-helper.conf` same as Step 1, but with the `dry_run` option turned off.
6. Do Steps 3 and 4 again, then check your SD card, there should be a `wz_flash-helper/backup/stock` directory where backups of your stock partitions are stored. Copy it to a safe place in case you need it for recovery.


**Notes:** Backup operations will automatically generate md5sum files for backed up partition images.
