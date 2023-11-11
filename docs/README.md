**Introduction** | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md)



## Features
- Serial or SSH connections are not needed! only SD card.
- Backup partitions
- Restore partitions
- Switch between Stock and OpenIPC firmware
- Dry run option for safety and debugging.
- Initramfs shell for manual debugging if you have a serial connection.
- Seamlessly boot to `wz_mini_hacks` on the next boot
- Support custom scripts to customize partitions

## Supported cameras
- Wyze Cam Pan
- Wyze Cam v2
- Wyze Cam v2 Pan
- Wyze Cam v3
- Wyze Cam Floodlight

## Notes
- It is highly recommended to enable `dry_run` to check if everything works before doing real operations.
- Backup is done first, then Restore, then Switch profile, and followed by Custom scripts.
- If one task fails, the program would exit immediately without doing any more operations.

## Warning
```
I am not responsible for bricking someone's camera.
DO NOT DISCONNECT POWER when the switch profile operation is going on,
this would brick your camera (unless you know how to recover with Ingenic Cloner or remove the flash chip and use SPI programmer).
It is also possible to brick the camera if you corrupt the uboot partition with your custom script or inject dangerous commands into the config file.
```

## Credits
- Gtxaspec with his ideas, tips, hard work on OpenIPC drivers, uboot SD card booting, and testing.
- Mnakada with their Docker image to build the SD card kernel from [their repo](https://github.com/mnakada/atomcam_tools)
- [OpenIPC](https://github.com/OpenIPC) project and people with their tools, firmware, and tips.
