[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | **Switch firmware** | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md) | [Changelog](Changelog.md) | [Limitation](Limitation.md)

> **❗ WARNING:**
> - DO NOT DISCONNECT POWER when the Switch firmware operation is going on. Doing this would brick your camera.
> - DO NOT share `initramfs.log` when you are switching to thingino with the `setup_thingino_env.sh` script, this log file contains your Wi-Fi name and password.

## Index

[Switch firmware overview](README_switch_firmware.md)

[Switch to stock firmware](README_switch_firmware_stock.md)

Switch to thingino firmware

## Overview

As thingino don't have fixed sizes for `kernel`, `rootfs` and `rootfs_data` partitions, wz_flash-helper views them as a single partition called `ota`. Therefore backup and restore operations will be on that merged partition. They can't be read or written individually.
The thingino firmware requires three partition images for: `boot`, `kernel` and `ota`. It can also be flashed using firmware image which contains all the needed partitions.

## Guide

**Step 1: [Setup](README_setup.md)**

**Step 2: [Obtain your camera hardware info](https://github.com/archandanime/wz_flash-helper/blob/main/docs/README_FAQs.md#how-can-i-obtain-my-camera-hardware-information)**

**Step 3: Prepare partition images**

> **❗ WARNING:**
> - Be careful to download the correct thingino build corresponding with your camera SoC (eg. `t31a` and `t31x` are different). Using the wrong build would brick your camera.

Download thingino firmware image from [thingino Releases](https://github.com/themactep/thingino-firmware/releases/tag/firmware), then rename the file to `thingino_[SoC]_firmware.bin` and place it under the `wz_flash-helper/restore/thingino/` directory on your SD card.

**Step 4: Generate .sha256sum files** using [this guide](https://github.com/archandanime/wz_flash-helper/blob/main/docs/README_FAQs.md#how-can-i-generate-sha256sum-files-for-partition-images)

Example for t31x:

![Alt text](https://raw.githubusercontent.com/archandanime/wz_flash-helper/main/images/switch_firmware_thingino.png)

**Step 5: Edit the custom script setup_thingino_env.sh**

Because Wyze cameras don't have Ethernet, Wi-Fi authentication information needs to be configured by setting U-boot env variables so your camera can connect to your home Wi-Fi network after thingino boots up. The `setup_thingino_env.sh` script under the `wz_flash-helper/scripts/` directory would help you to do the job.

To get the `setup_thingino_env.sh` script work, edit the script to set your Wi-Fi name (SSID) and password. Optionally, you can set your camera's MAC address and Timezone.

> **❗ WARNING:** If you forget to run this script by setting the `enable_custom_scripts` on `general.conf`, your camera would not be able to connect to Wi-Fi. In order to fix, you have to run the program again with it enabled.

**Step 6: Edit the program configuration file**

Edit `general.conf` with:
```
restore_partitions="no"
switch_firmware="yes"
next_firmware="thingino"

copy_new_sdcard_kernel="no"

enable_custom_scripts="yes"
custom_scripts="setup_thingino_env.sh"

re_run="yes"

manual_model="<camera model code>"
```

**Step 7: Power on**

Insert your SD card into your camera and power it on. It would take about 3 minutes to finish writing all partitions, then it will reboot to write `env` variables, and once again to thingino firmware.

**Note:** If your camera doesn't automatically reboots after first boot, please re-powering the camera to force a reboot.

After your camera finishes booting, you can use an IP scanner (e.g. nmap) to figure out its IP address and connect to it using SSH.

thingino default SSH username is `root` and password is `root`.
