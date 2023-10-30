[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | **Other options** | [FAQs](README_FAQs.md)

# Guide for other options


## Specify the boot image on the SD card that will be used on the next boot
If you are using wz_mini_hacks with stock profile, you can rename wz_mini's boot image to `sdcard_boot.wz_mini` and specify that file name with the `continue_boot_img_filename` option.
After all operations are finished, this file will be renamed to:
- `factory_ZMC6tiIDQN` if your camera is running stock profile on T20
- `factory_t31_ZMC6tiIDQN` if your camera is running stock profile on T31
- `factory_0P3N1PC_kernel` if your camera is running OpenIPC profile

This boot image to be booted on the next boot without having to pull the SD card and rename it manually. Seamless transition!


## Run a custom script
With the `custom_script` option, you can write a script and this script will be executed after backup/restore/switch_profile operations are finished. This is useful if you want to do extra modification from initramfs environment.

-----
**Note:**
- If you are on OpenIPC profile, boot image specified with `continue_boot_img_filename` will be renamed to `factory_0P3N1PC_kernel` instead.
- SD card boot image will not be renamed if `dry_run` is set to `yes`.
- Custom script will not not run if `dry_run` is set to `yes`.
- Custom script does not necessarily have to be on the SD Card top directory, you can put its path on the option to make it run from somewhere else.

