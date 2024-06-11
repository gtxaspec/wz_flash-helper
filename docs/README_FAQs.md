[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch firmware](README_switch_firmware.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | **FAQs** | [Changelog](Changelog.md) | [Limitation](Limitation.md)

### The program does not work at all. Help!

Make sure that:
- Your SD card partition table is **MBR** and partition format is **FAT32**.
- You downloaded the correct release for your camera SoC.
- The SD card kernel has the correct name without the `.wz_flash-helper` extension. The program adds the extension to its kernel file after it is finished to prevent itself from booting multiple times; therefore you need to rename it back if you want to run the program again.

### What are use cases for this program?

- If you need to backup your camera partitions or restore them.
- If you need to flash customized partitions for stock firmware.
- If you need switch between firmware without serial connection (even remotely!)

### How can I access serial console?

Connect 3 pins: Tx, Rx and GND from your camera to your computer with a USB-to-TTL adapter.

> **❗ WARNING:** DO NOT CONNECT the 3.3V or 5V pin from the USB-to-TTL serial converter to your camera. This would fry your camera PCB.

If you are on Linux, run:
```
sudo picocom /dev/ttyUSB0 -b 115200 -l | tee /tmp/serial.log
```

If you are on Windows, use a third-party tool (eg. PuTTY), then set baud rate to `115200` and select the correct COM port for your USB-to-TTL serial converter.

### How can I obtain my camera hardware information?

**1. Obtain camera SoC info**

Edit `general.conf` with:
```
dry_run="yes"
backup_partitions="no"
restore_partitions="no"
switch_firmware="no"
```

Then insert your SD card into your camera, power on, wait till the program is finished, then check `initramfs_serial.log` for "chip group" information. That is your camera SoC.

**2. Obtain Wi-Fi MAC address**

There are three ways:

- Checking the bottom of your camera
- Checking with Wyze mobile app: Settings -> Device Info -> MAC address
- Running `ifconfig wlan0` with SSH or serial connection

### How can I generate .sha256sum files for partition images?

If you are on Linux, run:
```
for i in *.bin; do sha256sum $i > $i.sha256sum; done
```

If you are on Windows, first, make sure that your Powershell version is 5.0 or newer (run `$PSVersionTable` to check), then:
- Copy the script `generate_hash_files.ps1` from `wz_flash-helper/scripts/` directory to the partition images location.
- Right click the new script `generate_hash_files.ps1` then select `Run with Powershell`. The script will generate .sha256sum files for you.

### Can you add support for my camera?

Yes, with the conditions that:

- Your camera does not have verified boot on hardware level.
- Your camera U-boot supports booting a kernel file from SD card or you can compile and flash a U-boot (by rooting or removing the flash chip) that has that functionality.
- Your camera has NOR flash (NAND is not supported yet)

### How does switching firmware work?

On NOR flash and raw NAND flash, there is no partition table; the partition layout is actually seen by the kernel by setting `CONFIG_CMDLINE= ... mtdparts=...` which will be passed to the `jz_sfc` driver. That option defines each partition size to let partition data be read and written to the correct addresses.

The partitions can also be defined by setting their sizes and offsets from the start address (`0x0`). What we do is define partition offsets and the size of both the current and next firmware so we can read, write or mount those partitions correctly.

The Switch firmware operation reads the partition images that you provide and writes them to the correct addresses of each partition on the next firmware.

### What is a profile?

`wz_flash-helper` does not care about the firmware you use (which is a set of binaries); it only cares about the partition information (name, MTD mapping number, filesystem type) of the firmware to read or write the partitions correctly. A profile provides that information to let the program do its job. It includes:

- List of all partition names with their properties:
   - MTD mapping number
   - List of partitions that store user data to create archives for them with the Backup operation
   - Filesystem types (`raw`, `jffs2`, `squashfs` or `vfat`) of each partition in case they need to be mounted
   - List of mandatory partitions that must be written when switching to that firmware (when `switch_firmware_with_all_partitions` is disabled) and list of tasks to do (`write`, `erase,`,`format`, `leave`) with other partitions.

- Name of the SD card kernel that can be recognized and booted by that firmware U-boot
- Backup and restore paths where partition images are stored
- Model detection script (`detect_model.sh`) to detect camera model
- Profile detection script (`detect_firmware.sh`) to detect current firmware
- (Optional) Post-switch firmware script (`post_switch.sh`) to run after switching to that firmware
