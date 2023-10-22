[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch firmware](README_switch_fw.md) | **Other options**

## Specify the boot image on the SD card that will be used on the next boot
If you are using wz_mini_hacks with stock firmware, you can rename wz_mini's boot image to `factory_t31_ZMC6tiIDQN.wz_mini` and specify that file name with the `continue_boot_img_filename` option. After wz_flash-helper finishes its operations, this file will be renamed to `factory_t31_ZMC6tiIDQN` to allow this boot image to be booted on the next boot without having to pull the SD card and rename it manually. Seamless transition!

## Run a custom script
You can write a script and specify it in the `wz_flash-helper.conf` file with the `custom_script` option. This script will be executed after backup/restore operations are finished. This is useful if you want to write your configuration files into writable partition(s).


