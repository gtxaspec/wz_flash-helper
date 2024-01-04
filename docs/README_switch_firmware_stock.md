[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | **Switch firmware** | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md) | [Changelog](Changelog.md) | [Limitation](Limitation.md)

**❗ WARNING:**

- DO NOT DISCONNECT POWER when the switch firmware operation is going on. Doing this would brick your camera.
- DO NOT share `initramfs.log` when you are switching to OpenIPC with the `setup_openipc_env.sh` script, this log file contains your Wi-Fi name and password.
- Switching to wzmini firmware is not supported yet (it is actually supported, but the firmware is still in early development stage).

## Index

[Switch firmware overview](README_switch_firmware.md)

Switch to Stock firmware

[Switch to OpenIPC firmware](README_switch_firmware_openipc.md)

[Switch to wzmini firmware](README_switch_firmware_wzmini.md) 

## Overview

The Stock firmware for T20 requires seven partition images for: `boot`, `kernel`, `root`, `driver`, `appfs`, `config` and `para`.

The Stock firmware for T31 requires five partition images for: `boot`, `kernel`, `rootfs`, `app` and `configs`.

## Guide

**Step 1: [Setup](README_setup.md)**

**Step 2: Prepare partition images**

Place your Stock partition backup images along with their .sha256sum files under the `wz_flash-helper/restore/stock/` directory.

**Step 3: Edit the program configuration file**

Edit `general.conf` with:
```
restore_partitions="no"
switch_firmware="yes"
next_firmware="stock"
switch_firmware_with_all_partitions="no"
```

**Step 4: Power on**

Insert your SD card into your camera and power it on. It would take about 3 minutes to finish writing all partitions, then it will reboot to Stock firmware.
