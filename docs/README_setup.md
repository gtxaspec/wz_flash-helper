[Introduction](README.md) | **Setup** | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch firmware](README_switch_firmware.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md) | [Changelog](Changelog.md) | [Limitation](Limitation.md)



**⚠️ IMPORTANT:**
- Make sure that your SD card partition table is **MBR** and partition format is **FAT32**.
- If your camera is Wyze Cam Pan or Wyze Cam v2, before using the program, you need to update your camera bootloader to with the latest version using [this guide](https://github.com/gtxaspec/wz_mini_hacks/wiki/Setup-&-Installation).

-----

## Guide

Download the correct release from the [Release page](https://github.com/archandanime/wz_flash-helper/releases/latest) for your camera SoC and extract it to your SD card.

Example for T31:

![Alt text](https://raw.githubusercontent.com/archandanime/wz_flash-helper/main/images/setup_01.png)

## Notes

- The program adds the `.wz_flash-helper` extension to its kernel file after it is finished to prevent itself from booting multiple times; therefore you need to rename it back if you want to run the program again.

- The program takes about 15 seconds to load before processing operations.
