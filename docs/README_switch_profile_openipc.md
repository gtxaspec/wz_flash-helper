
[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | **Switch profile** | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md) | [Changelog](Changelog.md)


**❗ WARNING:**
- DO NOT DISCONNECT POWER when the switch profile operation is going on. Doing this would brick your camera.
- DO NOT share `initramfs.log` when you are switching to OpenIPC with the `setup_openipc_env.sh` script, this log file contains your Wi-Fi name and password.
- Switching to wzmini profile is not supported yet (it is actually supported but the firmware is still in early development stage).

-----

## 📋 Index

[Switch profile overview](README_switch_profile.md)

[Switch to Stock profile](README_switch_profile_stock.md)

Switch to OpenIPC profile

[Switch to wzmini profile](README_switch_profile_wzmini.md)

-----

## 📄 Overview

The openipc profile requires four partition images for: `boot`, `env`, `kernel` and `rootfs`.

## 🛠️ Guide

**Step 1: [Setup](README_setup.md)**

**Step 2: [Obtain your camera hardware info](https://github.com/archandanime/wz_flash-helper/blob/main/docs/README_FAQs.md#how-can-i-obtain-my-camera-hardware-information)**

**Step 3: Prepare partition images**

**❗ WARNING:**
- Be careful to download the correct OpenIPC build corresponding with your camera SoC (eg. `t31a` and `t31x` are different). Using the wrong build would brick your camera.
- Don't download OpenIPC official uboot image because it doesn't support from SD card kernel that wz_flash-helper relies on to work.

Download OpenIPC Uboot image from [this repo](https://github.com/gtxaspec/u-boot-ingenic/releases/tag/latest) with this format: `u-boot-[SoC]-universal.bin`

Download OpenIPC tarball that contains kernel and rootfs images from OpenIPC [Release page](https://github.com/OpenIPC/firmware/releases/tag/latest) with this format: `openipc.[chip family]-[flash type]-ultimate.tgz`

Then extract the firmware archive, place everything under the `wz_flash-helper/restore/openipc/` directory on your SD card, and rename the partition images:

- boot: `u-boot-[SoC]-universal.bin` to `openipc_[SoC]_boot.bin`
- env: `openipc_[chip family]_env.bin.[SoC]` to `openipc_[SoC]_env.bin`
- kernel: `uImage.[SoC]` to `openipc_[SoC]_kernel.bin`
- rootfs: `rootfs.squashfs.[SoC]` to `openipc_[SoC]_rootfs.bin`

**Step 4: Generate .sha256sum files** using [this guide](https://github.com/archandanime/wz_flash-helper/blob/main/docs/README_FAQs.md#how-can-i-generate-sha256sum-files-for-partition-images)

Example for t31x:

![Alt text](https://raw.githubusercontent.com/archandanime/wz_flash-helper/main/images/switch_profile_openipc.png)

**Step 5: Edit the custom script setup_openipc_env.sh**

Because Wyze cameras don't have Ethernet, Wi-Fi authentication information and driver need to be configured by setting uboot env variables so your camera can connect to your home Wi-Fi network after OpenIPC boots up. The `setup_openipc_env.sh` script under the `wz_flash-helper/scripts/` directory would help you to do the job.

To get the `setup_openipc_env.sh` script work, edit the script to set your Wi-Fi name (SSID) and password, optionally set your camera's MAC address and Timezone.

The Wi-Fi driver doesn't need to be set manually because it is automatically detected.

**❗ WARNING:** If you forget to run this script, your camera would not be able to connect to Wi-Fi. In order to fix, you have to run the program again with it enabled.

**Step 6: Edit the program configuration file**

Edit `general.conf` with:
```
restore_partitions="no"
switch_profile="yes"
next_profile="openipc"
switch_profile_with_all_partitions="no"

enable_custom_scripts="yes"
custom_scripts="setup_openipc_env.sh"
```

**Step 7: Power on**

Insert your SD card into your camera and power it on. It would take about 3 minutes to finish writing all partitions, then it will reboot to OpenIPC firmware.

After your camera finishes booting, you can use an IP scanner (e.g. nmap) to figure out its IP address and connect to it using SSH.

OpenIPC default SSH username is `root` and password is `12345`.
