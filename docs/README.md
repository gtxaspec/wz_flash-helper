**Introduction** | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch firmware](README_switch_fw.md) | [Other options](README_boot_img_next_boot.md)

## Still under development, you can not use this yet until there is a release


# wz_flash-helper

Automatic parttion backup/restore tool for T20/T31 cameras, works with both stock and OpenIPC firmware.

You can also switch between stock and OpenIPC firmware without a scratch.

## Features
- No serial connection or SSH is needed! only SD card.
- Custom script to run after backup/restore.
- Dry run option for safety and debugging.
- Seamless transition to a new boot image on SD card after backup/restore.
- Initramfs shell for manual debugging is available if you have a serial connection.


## Supported cameras
- Wyze Cam Pan
- Wyze Cam v2
- Wyze Cam v2 Pan
- Wyze Cam v3
- Wyze Cam Floodlight


**Note:**
- It is highly recommended to enable `dry_run` to check if everything works before doing real operations.
- Backup is done first, then Restore and followed by Custom script.
- During backup operations, the blue LED would be blinking.
- During restore operations, the red LED would be blinking.
- During switch firmware operations, both the blue LED and the red LED would be blinking.

## Warning
```
I am not responsible for bricking someone's cameras.
DO NOT DISCONNECT POWER when restore operations are going on specially when uboot is being flashed,
this would hardbrick your camera(unless you know how to remove the flash chip and use SPI programmer).
It is also possible to hardbrick the camera with your custom script or you inject dangerous commands to the config file.
```


## Credits
- Gtxaspec with his ideas, tips and hard work on OpenIPC drivers and uboot SD card booting.
- Mnakada with their docker image to build the boot image from [their repo](https://github.com/mnakada/atomcam_tools)
- [OpenIPC](https://github.com/OpenIPC) project with their tools, firmware and help.
