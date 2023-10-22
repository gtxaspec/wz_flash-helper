[Introduction](README.md) | [Setup](README_setup.md) | **Backup** | [Restore](README_restore.md) | [Switch firmware](README_switch_fw.md) | [Other options](README_boot_img_next_boot.md)

## Backup partitions
1. Download [lastest release](https://github.com/archandanime/wz_flash-helper/releases/latest) then extract the `wz_flash-helper` directory and `factory_t31_ZMC6tiIDQN` to your SD card.
2. Edit the config file `wz_flash-helper.conf` with:
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


**Notes:**
- You need md5sum files of the partition images that you want to restore in `<partition name>.ms5sum` format. Backup operations will automatically generate md5sum files.
