[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | **FAQs**



## The program does not work at all. Help!

Make sure that:
- Your SD card partition is **MBR**.
- You downloaded the correct release for your camera SoC.
- The SD card kernel has the correct name(`factory_..._ZMC6tiIDQN`) without the `.wz_flash-helper` extension. The program adds the extension to the file after it finishes running to stop it from being booted multiple times.

## How does switching profile work?

On NOR flash, there is no partition table; the partition layout is actually seen by the kernel by setting `CONFIG_CMDLINE= ... mtdparts=...`. That option defines each partition size to let partition data be read and written to the correct addresses.

The partitions can also be defined by setting their sizes and offsets from the start address (0x0). What we do is define partition offsets and the size of both the current and next profile so we can both read and write those partitions correctly.

When the switch profile operation is going on, it reads the partition images that you provide and writes them to the partitions of the next profile. It is just that simple.

## What is a profile?

`wz_flash-helper` does not care about the firmware you use (which is a set of binaries); it only cares about the partition information (name, MTD mapping number, filesystem type) of the firmware to read or write the partitions correctly. A profile provides that information to let the program do its job.

A profile includes:
- List of all partition names
- MTD mapping number of each partition
- List of partitions that store user data to create archives for them with backup operation
- Partition types (`raw`, `jffs2`, `squashfs` or `vfat`) of each partition in case they need to be mounted
- Name of SD card kernel
- Backup and restore path to hold partition images
- List of mandatory partitions that must be written when switching to that profile (when `witch_profile_with_all_partitions` is disabled) and list of tasks to do (`ignore`, `erase,`,`format`, `leave`) with other partitions.
- Detection script to detect that profile (usually by analyzing boot partition strings)

## How can I add a new profile?

If your new profile is used for existing chip group families, you only need to add the information above the new profile.

If you new profile is used for a new chip group, you also need to:
- Add `leds_gpio.d/(chip family).sh` to define LED GPIO pins.
- Add `initialize_gpio.d/(chip family).sh` to define how to initialize GPIO pins to enable LEDs (maybe also SD card).
- Edit `profile.d/detect_chip_group.sh` to define your new SoC name belongs to which chip group (eg. `t20`, `t31a`, `t31x`) to select the right build for OpenIPC.
