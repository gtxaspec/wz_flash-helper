[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | **Other options** | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md) | [Changelog](Changelog.md)


**✅ Option: `dry_run`**

With this option, you can see what commands are executed with by the program without having them run. It would also help with obtaining your camera hardware and firmware information.

With this option enabled:

- No operation will be done.
- Custom scripts will not be run.
- SD card kernel will not be copied and renamed.

**✅ Option: `new_sdcard_kernel`**

With this option, you can specify the SD card kernel that will be used on the next boot.

If you are using `wz_mini_hacks` with Stock firmware, you can rename wz_mini's kernel file to `sdcard_boot.wz_mini` and specify that filename with the option.

After all operations are finished, that file will be copied and renamed to:

- `factory_ZMC6tiIDQN` if your camera is on T20
- `factory_t31_ZMC6tiIDQN` if your camera is T31

This kernel file will be booted on the next boot without having to pull the SD card and rename it manually. Seamless transition!

If you are on OpenIPC profile, SD card kernel specified with `new_sdcard_kernel` will be copied and renamed to `factory_0P3N1PC_kernel` instead. Unless you are using `wz_mini_hacks` or using the SD card kernel for personal purposes, you should disable it.

**✅ Option: `custom_scripts`**

With this option, you can write scripts and get them executed by the program after backup/restore/switch_profile operations are finished. This is useful for extra modifications to your partitions from the initramfs environment.
