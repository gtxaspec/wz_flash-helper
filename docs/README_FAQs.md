[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | **FAQs**


### The program does not work at all. Help!

Make sure that:
- Your SD card partition table is **MBR** and partition format is **FAT32**.
- You downloaded the correct release for your camera SoC.
- The SD card kernel has the correct name(`factory_..._ZMC6tiIDQN`) without the `.wz_flash-helper` extension. The program adds the extension to its kernel file after it is finished to prevent itself from booting multiple times; therefore you need to rename it back if you want to run the program again.

### How can I access serial console?

Connect 3 pins: Tx, Rx and GND from your camera to your computer with a USB to TTL adapter. Then run this command from your terminal:
```
sudo picocom /dev/ttyUSB0 -b 115200 -l | tee /tmp/serial.log
```

Alternatively you can use PuTTY.

### How can I obtain my camera hardware information?

**1. Obtain camera SoC info**

Edit `general.conf` with:
```
dry_run="yes"
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
for i in *.bin *.tar.gz; do sha256sum $i > $i.sha256sum; done
```

If you are on Windows with Poweshell 5.0 or newer:
- Copy the script `generate_hash_files.ps1` from `wz_flash-helper/scripts/` directory to the partition images location.
- Right click the script `generate_hash_files.ps1` then select `Run with Powershell`. The script will generate .sha256sum files for you.

### Can you add support for my camera?

Yes, with the condition that your camera uboot supports booting a kernel file from SD card. Otherwise, you have to root it then compile and flash a uboot that has that functionality.

### How does switching profile work?

On NOR flash, there is no partition table; the partition layout is actually seen by the kernel by setting `CONFIG_CMDLINE= ... mtdparts=...` which will be passed to `jz_sfc` driver. That option defines each partition size to let partition data be read and written to the correct addresses.

The partitions can also be defined by setting their sizes and offsets from the start address (0x0). What we do is define partition offsets and the size of both the current and next profile so we can both read and write those partitions correctly.

When the switch profile operation is going on, it reads the partition images that you provide and writes them to the partitions of the next profile. It is just that simple.

### What is a profile?

`wz_flash-helper` does not care about the firmware you use (which is a set of binaries); it only cares about the partition information (name, MTD mapping number, filesystem type) of the firmware to read or write the partitions correctly. A profile provides that information to let the program do its job. It includes:

- List of all partition names
- MTD mapping number of each partition
- List of partitions that store user data to create archives for them with backup operation
- Partition types (`raw`, `jffs2`, `squashfs` or `vfat`) of each partition in case they need to be mounted
- Name of SD card kernel that can be recognized and booted by uboot
- Backup and restore paths to hold partition images
- List of mandatory partitions that must be written when switching to that profile (when `witch_profile_with_all_partitions` is disabled) and list of tasks to do (`write`, `erase,`,`format`, `leave`) with other partitions.
- Model detection script to detect camera model
- Profile detection script to detect current profile

### How can I add a new profile?

If your new profile is used for existing chip group families, you only need to add the information above the new profile.

If you new profile is used for a new chip family, you also need to:
- Add `leds_gpio.d/(chip family).sh` to define LED GPIO pins.
- Add `initialize_gpio.d/(chip family).sh` to define how to initialize GPIO pins to enable LEDs (maybe also SD card).
- Edit `profile.d/detect_chip_group.sh` to define your new SoC name belongs to which chip group (eg. `t20`, `t31a`, `t31x`) to select the right build for OpenIPC.
- Add partition mapping for the partitions of the new profile to kernel config.

### How can I restore the boot partition?

**❗ WARNING:** Doing this might brick your camera, only do when you know what you are doing.

To restore the `boot` partition, add this hidden option to [profile].conf under the `wz_flash-helper/restore/[profile]` directory:
```
hidden_option_restore_boot="yes"
```
