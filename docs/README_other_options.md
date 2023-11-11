
[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | **Other options** | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md)



## Specify the SD card kernel that will be used on the next boot

Option: `new_sdcard_kernel`

If you are using `wz_mini_hacks` with `stock` profile, you can rename wz_mini's kernel file to `sdcard_boot.wz_mini` and specify its filename with the option.

After all operations are finished, that file will be renamed to:

- `factory_ZMC6tiIDQN` if your camera is running Stock profile on T20
- `factory_t31_ZMC6tiIDQN` if your camera is running Stock profile on T31

This kernel file will be booted on the next boot without having to pull the SD card and rename it manually. Seamless transition!


## Run a custom script

Option: `custom_scripts`

You can write scripts, and those scripts will be executed after backup/restore/switch_profile operations are finished. This is useful if you want to do extra modifications to your partitions from initramfs environment.

-----
**ℹ️ Note:**
- If you are on OpenIPC profile, SD card kernel specified with `new_sdcard_kernel` will be renamed to `factory_0P3N1PC_kernel` instead. Unless you are using `wz_mini_hacks` or using the SD card kernel for personal purposes, you should disable it.
- SD card kernel will not be renamed if `dry_run` is enabled.
- Custom script will not run if `dry_run` is enabled.
- Custom script does not necessarily have to be on the SD Card top directory, you can put its path on the option to make it run from somewhere else.

