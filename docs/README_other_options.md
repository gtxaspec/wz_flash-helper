[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch firmware](README_switch_fw.md) | **Other options**

## Specify the boot image on the SD card that will be used on the next boot
If you are using wz_mini_hacks with stock firmware, you can rename wz_mini's boot image to `factory_t31_ZMC6tiIDQN.wz_mini` and specify that file name with the `continue_boot_img_filename` option. After all operations are finished, this file will be renamed to `factory_t31_ZMC6tiIDQN` to allow this boot image to be booted on the next boot without having to pull the SD card and rename it manually. Seamless transition!

## Run a custom script
With the `custom_script` option, you can write a script and this script will be executed after backup/restore operations are finished. This is useful if you want to do extra modification from initramfs environment.



**Note:**
- If you are on OpenIPC firmware, boot image specified with `continue_boot_img_filename` will be renamed to `factory_0P3N1PC_kernel` instead.
- Custom script is not run if `dry_run` is set to `yes`.
- Custom script does not necessarily have to be on the SD Card top directory, you can put its path on the option to make it run from somewhere else.


