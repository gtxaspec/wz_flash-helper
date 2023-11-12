
[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | **Switch profile** | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md)



**❗ WARNING:**
- DO NOT DISCONNECT POWER when the switch profile operation is going on. This would brick your camera.
- Switching back to Stock from OpenIPC is not supported yet. If you have switched to OpenIPC, you have to use SSH or serial connection to rollback.

-----

## Switch from Stock to OpenIPC profile

**Step 1:** [Setup](README_setup.md)

**Step 2: Obtain your camera hardware info**
1. SoC type
Connect to your camera using SSH/serial and download the `ipcinfo` tool by running:
```
cd /tmp
wget --no-check-certificate https://github.com/OpenIPC/ipctool/releases/download/latest/ipcinfo-mips32
chmod +x ipcinfo-mips32
./ipcinfo-mips32 --chip-name
```
If the chip name is:
- `t31x`, `t31zl`, or `t31zx` then your SoC is `t31x`
- `t31a`, then your SoC is `t31a`
- `t20`, `t20x`, then your SoC is `t20x`

2. Wi-Fi MAC address

There are three ways:
- Check the bottom of the camera
- Check Wyze mobile app: Device info -> MAC
- Run `ifconfig wlan0` with SSH connection:

```
[root@WCV3:~]# ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 00:11:22:AA:BB:CC
...
```

**Step 3: Preparation**

**⚠️ IMPORTANT:** If your camera is T31, please find out if it is `t31a` or `t31x` to download the correct OpenIPC build. Using the wrong build would hard brick your camera.

Download correct OpenIPC build for your device from the OpenIPC [Release page](https://github.com/OpenIPC/firmware/releases/tag/latest), place them under the `wz_flash-helper/restore/openipc/` on your SD card and rename them with this format:
- openipc_[SoC]_boot.bin
- openipc_[SoC]_kernel.bin
- openipc_[SoC]_rootfs.bin

Generate .sha256sum files for all partition images:
- If you have WSL or Linux, run
```
for i in openipc_*.bin; do sha256sum $i > $i.sha256sum; done
```

- If you are on Windows, use Powershell to run:
```
certutil -hashfile "openipc_[SoC]_[partition image].bin" SHA256
```
then create .sha256sum file with this format:
```
(sha256sum)		openipc_[SoC]_[partition image].bin
```
for example:
```
a88a367b4f6c8a9ea703428b20617d4e8ccb4eba516962dc0fc37391adf0e2bc  openipc_t31x_boot.bin
```

**⚠️ IMPORTANT:** Each .sha256sum file must have only one line.

Example for t31x:

![Alt text](https://raw.githubusercontent.com/archandanime/wz_flash-helper/main/images/switch_profile_01.png)

**Step 4: Add uboot env variables**

Edit `setup_openipc_env.sh` under the `wz_flash-helper/scripts/` directory with your Wi-Fi name(SSID) and password. Optionally with MAC address and Timezone.

**Step 5: Edit the program configuration file**

Edit `general.conf` with:
```
restore_partitions="no"
switch_profile="yes"
next_profile="openipc"
switch_profile_with_all_partitions="no"

enable_custom_scripts="no"
custom_scripts="setup_openipc_env.sh"
```

**Step 6: Power on**

Insert your SD card into the camera and power it on. It would take about 3 minutes to finish writing all partitions, then it would reboot to OpenIPC firmware.

## Switch from OpenIPC to Stock profile
**Step 1: Preparation**

Place your backup of Stock partition images along with their sha256sum files under the `wz_flash-helper/restore/stock/` directory.

**Step 2: Edit the program configuration file**

Edit `general.conf` with:
```
restore_partitions="no"
switch_profile="yes"
next_profile="stock"
switch_profile_with_all_partitions="yes"
```

**Step 3: Power on**

Insert your SD card to the camera and power it on. It would take about 3 minutes to finish writing all partitions, then it will reboot to Stock firmware.

-----

Option: `switch_profile_with_all_partitions`

You can decide if all partitions will be written when switching profile.

When it is enabled:
- Switching from Stock to OpenIPC needs partition images of all partitions, including `rootfs_data`, if you don't have `rootfs_data` image, leave it disabled.
- Switching from OpenIPC also needs partition images of all partitions.

When switching from OpenIPC to Stock, some partitions, such as `aback`, `kback`, `backupa`, `backupd`, etc., don't need to be restored because they don't contain any meaningful data as they are used by Stock firmware as stage partition to install updates. You can disable this option to save time.

When switching from Stock to OpenIPC the first time, you have to leave if disabled because you don't have the `rootfs_data` partition image.

-----

Conditions for the switch profile operation to work:

1. All partition images of the profile types that you want to switch to must be present under either:
- `wz_flash-helper/restore/stock` directory or
- `wz_flash-helper/restore/openipc` directory

2. All partition images must come with their .sha256sum file in `(partition image).sha256sum` format.

-----

**ℹ️ Notes:**
- For switch profile operation to start, `restore_partitions` option must be disabled, like in the above configurations. If both the  `restore_partitions` and `switch_profile` options are enabled, both operations would not be done.
- All partition images are verified with their .sha256sum files before the switch_profile operation starts. If one file fails the verification, no change will be made.
- During the switch profile operation, both the blue LED and the red LED would be blinking.

