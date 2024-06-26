[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch firmware](README_switch_firmware.md) | **Other options** | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md) | [Changelog](Changelog.md) | [Limitation](Limitation.md)

**✅ Option: `dry_run`**

With this option, you can see what commands are executed with by the program without actually running them. It would also help with obtaining your camera hardware and firmware information.

With this option enabled:

- No operation will be done. Instead, the shell commands used by the operations will be printed out without being run.
- Custom scripts will not be run.
- SD card kernel will not be copied and renamed.

**✅ Option: `new_sdcard_kernel`**

With this option, you can specify the SD card kernel that will be used on the next boot.

If you are using `wz_mini_hacks` with stock firmware, you can rename wz_mini's kernel file to `sdcard_boot.wz_mini` and specify that filename with the option.

After all operations are finished, that file will be copied and renamed to:

- `factory_ZMC6tiIDQN` if your camera is T20
- `factory_t31_ZMC6tiIDQN` if your camera is T31

This kernel file will be booted on the next boot without having to pull the SD card and rename it manually. Seamless transition!

If you are on thingino firmware, SD card kernel specified with `new_sdcard_kernel` will be copied and renamed to `factory_0P3N1PC_kernel` instead. Unless you are using `wz_mini_hacks` or using the SD card kernel for personal purposes, you should disable it.

> Note: This option still works when you are switching firmware. This is useful to switch from thingino to stock firmware with installed `wz_mini_hacks`.

**✅ Option: `custom_scripts`**

With this option, you can write shell scripts and get them executed by the program after the Backup, Restore and Switch firmware operations are finished. This is useful for extra modifications to your partitions from the initramfs environment.

**✅ Option: `re_run`**

With this option, you can let the program run twice. This is useful to let thingino U-boot set some `env` variables on its first boot as it only sets these variables if the `env` partition is empty.

## Debug options

**✅ Option: `manual_current_firmware`**

You can set it manually to fix the corrupted rootfs partition partition (for stock firmware) that makes `current_firmware` detection fail. If you are on thingino, you also have to set `manual_model`.


**✅ Option: `manual_model`**

You can set it manually to work with corrupted `configs` or `cfg` partitions on stock firmware that makes model detection fail. Check the [Introduction page](README.md) for "Model code" to set your camera model correctly.

## Hidden options

**✅ Option: `skip_rename_prog_sdcard_kernel`**

This option makes wz_flash-helper skip renaming its SD card kernel to make the camera boot loop. It is solely used for testing.
