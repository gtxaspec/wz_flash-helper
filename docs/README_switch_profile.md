
[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | **Switch profile** | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md)



**❗ WARNING:**
- DO NOT DISCONNECT POWER when the switch profile operation is going on. This would brick your camera.
- Switching back to Stock from OpenIPC is not supported yet. If you have switched to OpenIPC, you have to use SSH or serial connection to rollback.

-----

## Switch to OpenIPC profile

**Step 1:** [Setup](README_setup.md)

**Step 2: Obtain your camera hardware info**

**1. Obtain your camera SoC**

Edit `general.conf` with:
```
dry_run="yes"
```

Then insert your SD card into your camera, power on, wait till the program is finished, check `initramfs_serial.log` for "chip group" information. That is your camera SoC.

**2. (Optional) Obtain your Wi-Fi MAC address**

There are three ways:

- Checking the bottom of the camera
- Checking with Wyze mobile app: Device info -> MAC
- Running `ifconfig wlan0` with SSH or serial connection

**Step 3: Prepare partition images**

**⚠️ IMPORTANT:** Be careful to download the correct OpenIPC build corresponding with your camera SoC (eg. `t31a` and `t31x` are different). Using the wrong build would hard brick your camera.

Download the correct firmware archive and uboot image for your camera from the OpenIPC [Release page](https://github.com/OpenIPC/firmware/releases/tag/latest), extract firmware archive and place everything under the `wz_flash-helper/restore/openipc/` directory on your SD card, and rename the partition images:

- `u-boot-[SoC]-universal.bin` to `openipc_[SoC]_boot.bin`
- `openipc_env.bin.[SoC]` to `openipc_[SoC]_env.bin`
- `uImage.[SoC]` to `openipc_[SoC]_kernel.bin`
- `rootfs.squashfs.[SoC]` to `openipc_[SoC]_rootfs.bin`

**Step 3: Generate .sha256sum files**

- If you have WSL or Linux, you only need to run:
```
for i in openipc_*.bin; do sha256sum $i > $i.sha256sum; done
```

- If you are on Windows, use Powershell to run:
```
certutil -hashfile "openipc_[SoC]_[partition name].bin" SHA256
```
then create .sha256sum file with this format:
```
(sha256sum)		openipc_[SoC]_[partition name].bin
```
for example:
```
a88a367b4f6c8a9ea703428b20617d4e8ccb4eba516962dc0fc37391adf0e2bc  openipc_t31x_boot.bin
```

**⚠️ IMPORTANT:** Each .sha256sum file must have only one line.

Example for t31x:

![Alt text](https://raw.githubusercontent.com/archandanime/wz_flash-helper/main/images/switch_profile_01.png)

**Step 4: Edit custom script to set uboot env variables**

**ℹ️ Note:** To let your camera connect to Wi-Fi, uboot env variables for Wi-Fi SSID, password and driver must be set. This can be done with help from `setup_openipc_env.sh` script.

Edit `setup_openipc_env.sh` under the `wz_flash-helper/scripts/` directory to set your Wi-Fi name(SSID) and password, optionally set your camera MAC address and Timezone. Wi-Fi driver would be automatically detected.

**Step 5: Edit the program configuration file**

Edit `general.conf` with:
```
restore_partitions="no"
switch_profile="yes"
next_profile="openipc"
switch_profile_with_all_partitions="no"

enable_custom_scripts="yes"
custom_scripts="setup_openipc_env.sh"
```

**Step 6: Power on**

Insert your SD card into your camera and power on. It would take about 3 minutes to finish writing all partitions, then it would reboot to OpenIPC firmware.

## Switch to Stock profile

**Step 1:** [Setup](README_setup.md)

**Step 2: Prepare partition images**

Place your Stock partition backup images along with their .sha256sum files under the `wz_flash-helper/restore/stock/` directory.

**Step 3: Edit the program configuration file**

Edit `general.conf` with:
```
restore_partitions="no"
switch_profile="yes"
next_profile="stock"
switch_profile_with_all_partitions="no"
```

**Step 4: Power on**

Insert your SD card to the camera and power it on. It would take about 3 minutes to finish writing all partitions, then it will reboot to Stock firmware.

## Switch to wzmini profile

(definitely not coming soon)

-----

Option: `switch_profile_with_all_partitions`

You can decide if all partitions will be written when switching profile.

When it is disabled, only necessary partitions for a barely functional camera are written.

- For OpenIPC: `boot`, `kernel` and `rootfs` are written; `rootfs_data` would be formatted.
- For Stock t20: `boot`, `kernel`, `root`, `driver`, `appfs`, `config` and `para` are written; `backupa` would be formatted.
- For Stock t31: `boot`, `kernel`, `rootfs`, `app` and `cfg` are written; `kback` would be formatted.

When it is enabled, all partition images are needed. This is only helpful when you need to write `rootfs_data` partition for OpenIPC.

On Stock firmware, some partitions, such as `aback`, `kback`, `backupa`, `backupd`, etc., don't need to be written because they don't contain any meaningful data as they are used by Stock firmware as stage partitions to install updates. You can disable this option to save time.

This option value has no effect when switching to wzmini profile as the `configs` partition is required for your camera to be functional.

-----

**ℹ️ Notes:**
- For switch profile operation to start, `restore_partitions` option must be disabled, like in the above configurations. If both the  `restore_partitions` and `switch_profile` options are enabled, both operations would not be done.
- All partition images are verified with their .sha256sum files before the switch_profile operation starts. If one file fails the verification, no change will be made.
- During the switch profile operation, both the blue LED and the red LED would be blinking.

