[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | **Switch firmware** | [Other options](README_boot_img_next_boot.md)

## Switch between stock and OpenIPC firmware
To switch from stock to OpenIPC firmware, you need these options on `wz_flash-helper.conf`:
```
restore_partitions="yes"
restore_fw_type="openipc"
```
all restore options for OpenIPC partitions must be enabled

To switch from OpenIPC to stock firmware, you need these options on `wz_flash-helper.conf`:
```
restore_partitions="yes"
restore_fw_type="stock"
```
all restore options for partitions with your camera SoC type must be enabled.

