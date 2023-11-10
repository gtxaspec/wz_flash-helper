
[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | **FAQs**



## The program does not work at all, help!

Make sure that:
- Your SD card partition is **MBR**.
- You downloaded the correct release for your camera SoC.
- The SD card kernel has the correct name(`factory_..._ZMC6tiIDQN`) without the `.wz_flash-helper` extension. The program adds the extension to the file after it finishes running to stop it from being booted multiple times.

## How does switching profile work?

On NOR flash, there is no partition table, the partition layout is actually seen by the kernel by setting `CONFIG_CMDLINE= ... mtdparts=...`. That option defines each partition size to let partition data be read and written into the correct addresses.

The partitions can also be defined by setting their sizes and offset from the start address(0x0). What we do is to define partition offsets, size of both current and next profile so we can both read/write those partition correctly.

When switch profile operation is going on, it reads partition images that you provide and write to the partitions of the next profile. It is just that simple.

## What is a profile?

`wz_flash-helper` does not care about what firmware(which is a set of binaries) that you use, it only cares about the partition information(name, MTD mapping number, filesystem type) of the firmware to read/write the partitions correctly. A profile defines provides that information to let the program do its jobs.

A profile includes:
- List of all partition names
- MTD mapping number of each partition
- List of partitions that store user data to create archives for them with backup operation
- Partition types(`raw`, `jffs2`, `squashfs` or `vfat`) of each partition in case they need to be mounted
- Name of SD card boot kernel
- Backup/restore path to hold partition images
- List of mandatory partitions that must be written when switching to that profile(when `witch_profile_with_all_partitions` is disabled), list of task to do(`ignore`, `erase,`,`format`, `leave`) with other partitions.
- Detection script to detect that profile(usually by analyzing bootl partition strings)

## How can I add a new profile?

If your new profile is used for existing chip group families, you only need to add the information above the the new profile. There is also a profile templates to let you do that easily.

If you new profile is used for a new chip group, you also need to:
- Add `leds_gpio.d/(chip family).sh` to define LEDs GPIO pins.
- Add `initialize_gpio.d/(chip family).sh` to define how to initialize GPIO pins to enable LEDs(maybe also SD card).
- Edit `profile.d/detect_chip_group.sh` to define your new SoC name belong to what chip group(eg. `t20`, `t31a`, `t31x`) to select the right build for OpenIPC.

