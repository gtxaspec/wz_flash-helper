[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | **Switch firmware** | [Other options](README_boot_img_next_boot.md)

## How to switch between stock and OpenIPC firmware


To switch from stock to OpenIPC firmware, edit `wz_flash-helper.conf` with:
```
restore_partitions="no"
switch_fw="yes"
switch_fw_to="openipc"
```

To switch from OpenIPC to stock firmware, edit `wz_flash-helper.conf` with:
```
restore_partitions="no"
switch_fw="yes"
switch_fw_to="stock"
```

Conditions for switch operations to work:
1. Current firmware type must be different from `restore_fw_type` value
2. All partition images of the firmware types that you want to switch to must present in either:
- `(SD card)/wz_flash-helper/restore/stock` or
- `(SD card)/wz_flash-helper/restore/openipc`
3. All partition images must come with their md5sum file in <partition image>.md5sum

**Note:** `restore_partitions` option must be disabled like the above configurations. If both `restore_partitions` and `switch_fw`are enabled, both operations would not be executed.
