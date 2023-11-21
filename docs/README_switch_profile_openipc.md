
[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | **Switch profile** | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md)


**❗ WARNING:**
- DO NOT DISCONNECT POWER when the switch profile operation is going on. This would brick your camera.
- Switching to other profiles from OpenIPC is not supported yet. If you have switched to OpenIPC, you need to use SSH or serial connection to switch manually.
- Switching to wzmini profile is not supported yet (it is actually supported but the firmware is still in early development stage)

-----

## 📋 Index

[Switch profile overview](README_switch_profile.md)

[Switch to Stock profile](README_switch_profile_stock.md)

Switch to OpenIPC profile

[Switch to wzmini profile](README_switch_profile_wzmini.md)

-----

## 📄 Overview

openipc profile requires four partition images for: `boot`, `env`, `kernel` and `rootfs`.

## 🛠️ Guide

**Step 1: [Setup](README_setup.md)**

**Step 2: [Obtain your camera hardware info](https://github.com/archandanime/wz_flash-helper/blob/main/docs/README_FAQs.md#how-can-i-obtain-my-camera-hardware-info)**

**Step 3: Prepare partition images**

**❗ WARNING:** Be careful to download the correct OpenIPC build corresponding with your camera SoC (eg. `t31a` and `t31x` are different). Using the wrong build would brick your camera.

Download the latest correct firmware archive (`openipc.[chip family]-[flash type]-ultimate.tgz`  file) and uboot image (`u-boot-[SoC]-universal.bin` file) for your camera from the OpenIPC [Release page](https://github.com/OpenIPC/firmware/releases/tag/latest).

Then extract the firmware archive, place everything under the `wz_flash-helper/restore/openipc/` directory on your SD card, and rename the partition images:

- `u-boot-[SoC]-universal.bin` to `openipc_[SoC]_boot.bin`
- `openipc_[chip family]_env.bin.[SoC]` to `openipc_[SoC]_env.bin`
- `uImage.[SoC]` to `openipc_[SoC]_kernel.bin`
- `rootfs.squashfs.[SoC]` to `openipc_[SoC]_rootfs.bin`

**Step 4: Generate .sha256sum files** using [this guide](https://github.com/archandanime/wz_flash-helper/blob/main/docs/README_FAQs.md#how-can-i-generate-sha256sum-files-for-partition-images)

Example for t31x:

![Alt text](https://raw.githubusercontent.com/archandanime/wz_flash-helper/main/images/switch_profile_openipc.png)

**Step 5: Edit the custom script setup_openipc_env.sh**

Because Wyze cameras don't have Ethernet, Wi-Fi authentication information and driver need to be configured by setting uboot env variables so your camera can connect to your home Wi-Fi network after OpenIPC boots up. The `setup_openipc_env.sh` script under the `wz_flash-helper/scripts/` directory would help you to do the job.

To get the `setup_openipc_env.sh` script work, edit the script to set your Wi-Fi name (SSID) and password, optionally set your camera's MAC address and Timezone.

The Wi-Fi driver doesn't need to be set manually because it is automatically detected.

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

Insert your SD card into your camera and power on. It would take about 3 minutes to finish writing all partitions, then it would reboot to OpenIPC firmware.

After your camera finishes booting, you can use an IP scanner (e.g. nmap) to figure out its IP address and connect to it using SSH.

OpenIPC default SSH username is `root` and password is `12345`.
