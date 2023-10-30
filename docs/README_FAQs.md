[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | **FAQs**

## How does switching profile work?
On NOR flash, there is no partition table, the partition layout is actually seen by the kernel by setting `CONFIG_CMDLINE= ... mtdparts=...`, that option defines each partition size to let partition data be read and written into the correct addresses.

The partitions can also be defined by setting their size and offset from start address(0x0). What we do is define partition offset and size of both current and next profile so we can both read and write into these partition correctly.

When switch profile operation is going on, it reads partition images that you provide and write to the partitions of the next profile. It is just that simple.


## What is a profile?
`wz_flash-helper` does not care about what firmware(which is a set of binaries) you use, it only cares about the partition information(name, MTD mapping number, filesystem type) of the firmware to read/write the partitions correctly. A profile defines provides that information to let `wz_flash-helper` do its jobs.

A profile includes:
- List of all partition names
- MTD mapping number of each partition
- List of partitions that store user data to create archives for them with backup operation
- Partition types(`raw`, `jffs2`, `squashfs`, `vfat`) of each partition in case they need to be mounted
- Name of SD card boot image
- Backup/restore path to hold partition images
- List of mandatory partitions that must be written when switching to that profile(when `witch_profile_with_all_partitions` is disabled), list of task to do(`ignore`, `erase`) with other partitions.
- Detection script to detect that profile(usually by analyzing bootloader partition strings)


## How can I add a new profile?
If your new profile is used for existing chip families, you only need to add the information above the the new profile. There is also a template profile profile to let you do that easily.

If you new profile is used for a new chip family, you also need to:
- Add `leds_gpio.d/(chip family).sh` to define LEDs GPIO pins
- Add `initialize_gpio.d/(chip family).sh` to define how to initialize GPIO pins to enable LEDs(maybe also SD card).
- Edit `profile.d/detect_chip_group.sh` to define your new SoC name belong to what chip group(eg. t20, t31a, t31x) to select the right build for OpenIPC.
