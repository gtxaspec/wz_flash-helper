[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | **Restore** | [Switch firmware](README_switch_fw.md) | [Other options](README_boot_img_next_boot.md)

## Restore partitions
1. Download [lastest release](https://github.com/archandanime/wz_flash-helper/releases/latest) then extract the `wz_flash-helper` directory and `factory_t31_ZMC6tiIDQN` to your SD card. If you are on OpenIPC firmware, rename it to `factory_0P3N1PC_kernel`.
2. Edit `wz_flash-helper.conf` to select the firmware type that you want to restore("stock" or "openipc")
3. Edit `wz_flash-helper.conf` to select partitions to be restored. If you are switching between stock and OpenIPC firmware, enable restore options for all partitions of the corresponding firmware type.
4. Insert your SD card into your camera and reboot.

