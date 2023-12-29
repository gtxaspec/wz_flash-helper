**Introduction** | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md) | [Changelog](Changelog.md) | [Limitation](Limitation.md)



## Features

- Backup partitions
- Restore partitions
- Switch between Stock, wzmini and OpenIPC firmware
- No need to disassemble your camera
- Dry run option debugging
- Initramfs shell for manual debugging if you have a serial connection
- Seamlessly boot to `wz_mini_hacks` on the next boot
- Customize partitions with custom scripts support
- Windows-friendly setup progress

## Supported cameras

| Camera              |  SoC  | Support status | Model code  |
| ------------------- | ----- | -------------- | ----------- |
| Wyze Cam v2         |  t20  | ✅ Supported   | `v2`        |
| Wyze Cam Pan        |  t20  | ⚠️ Untested    | `pan_v1`    |
| Wyze Cam v3         |  t31  | ✅ Supported   | `v3`        |
| Wyze Cam v2 Pan     |  t31  | ⚠️ Untested    | `pan_v2`    |
| Wyze Cam Floodlight |  t31  | ⚠️ Untested    | `v3`        |
| ATOM Cam 2          |  t31  | ⚠️ Untested    | `v3c`       |

## Disclaimer

```
I am not responsible for bricking someone's cameras.
DO NOT DISCONNECT POWER when the switch profile operation is going on, this would brick your camera (unless you know how to recover with Ingenic Cloner or remove the flash chip and use SPI programmer).
It is also possible to brick your camera if you corrupt the uboot partition with your custom script or inject dangerous commands into the config file.
```

## Credits

- Gtxaspec with his ideas, tips, and hard work on OpenIPC drivers, uboot SD card booting, and testing.
- Mnakada with their Docker image to build the SD card kernel from [their repo](https://github.com/mnakada/atomcam_tools)
- [OpenIPC](https://github.com/OpenIPC) project and people with their tools, firmware, and tips.
