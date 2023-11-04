[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | **Switch profile** | [Other options](README_other_options.md) | [Build](README_build.md) | [FAQs](README_FAQs.md)



**WARNING:** DO NOT DISCONNECT POWER when switch profile operation is going on. This would brick your camera.

## How to switch from stock to OpenIPC profile

**Step 0: Obtain your camera hardware info**
1. SoC type
Connect to your camera using SSH/serial and download `ipcinfo` tool by running:
```
cd /tmp
wget --no-check-certificate https://github.com/OpenIPC/ipctool/releases/download/latest/ipcinfo-mips32
chmod +x ipcinfo-mips32
./ipcinfo-mips32 --chip-name
```
If the chip name is:
- `t31x`, `t31zl`, or `t31zx` then your SoC type is `t31x`
- `t31a`, then your SoC type is `t31a`
- `t20x`, then your SoC is `t20x`

2. Wi-Fi MAC address

There are 3 ways:
- Checking the bottom of the camera
- Check Wyze mobile app: Device info -> MAC
- Run `ifconfig wlan0` with SSH connection:

```
[root@WCV3-Outdoor:~]# ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 00:11:22:AA:BB:CC
...
```

**Step 1: Preparation**

**IMPORTANT:** If your camera is T31, please find out if it is `T31a` or `T31x` to download the correct OpenIPC build. Using the wrong build would hard brick your camera.

Download corrrect OpenIPC build from OpenIPC release page for your device, place them in `(SD card)/wz_flash-helper/restore/openipc/` and rename them to:
- openipc_[SoC]_boot.img
- openipc_[SoC]_kernel.img
- openipc_[SoC]_rootfs.img

Generate sha256 files for all partition images:
- If you are on Windows, use a Powershell:
```
certutil -hashfile "openipc_[SoC]_[partition image].bin" SHA256
 ``
 
- If you have WSL or Linux, run
```
for i in openipc_*.bin; do sha256 $i > $i.sha256sum; done
```

**Step 2: Add your uboot env variables**
Edit `setup_openipc_env.sh` inside `wz_flash-helper/scripts/` directory with your Wi-Fi name(SSID), password. Optionally with MAC address and Timezone.

**Step 3: Edit the program configuration file**
Edit `general.conf` with:
```
restore_partitions="no"
switch_profile="yes"
next_profile="openipc"
switch_profile_with_all_partitions="no"

enable_custom_script="yes"
custom_script="setup_openipc_env.sh"
```

**Step 4: Power on**
Insert your SD card to the camera and power it on. It would take about 3 minutes to finish writing all partitions, then it will reboot to OpenIPC firmware.

## How to switch from OpenIPC to stock profile
**Step 1: Preparation**
Place your backup of stock partition images along with their md5 files at `(SD card)/wz_flash-helper/restore/stock/`

**Step 2: Edit the program configuration file**
Edit `general.conf` with:
```
restore_partitions="no"
switch_profile="yes"
next_profile="stock"
switch_profile_with_all_partitions="yes"
```

**Step 4: Power on**
Insert your SD card to the camera and power it on. It would take about 3 minutes to finish writing all partitions, then it will reboot to stock firmware.

## `switch_profile_with_all_partitions` option

With the option `switch_profile_with_all_partitions=` in `general.conf`, you can decide when switching profile, all partition images will be used or not.
When it is enabled:
- Switching from stock to OpenIPC needs partition images of all partitions including `rootfs_data`, if you don't have `rootfs_data` image, leave it disabled.
- Switching from OpenIPC also needs partition images of all partitions.

When switching from OpenIPC to stock, some partitions such as `aback`, `kback`, `backupa`, `backupd`, etc. they don't need to be restored because they don't contain any anything as they are used by stock firmware as stage partition to install updates. You can disable this option to save time.

When switching from stock to OpenIPC the first time, you have to leave if disabled because you don't have `rootfs_data` partition image.



-----
Conditions for switch profile operation to work:
1. All partition images of the profile types that you want to switch to must present in either:
- `(SD card)/wz_flash-helper/restore/stock` or
- `(SD card)/wz_flash-helper/restore/openipc`
2. All partition images must come with their md5sum file in `<partition image>.md5sum` format.


**Note:**
- `restore_partitions` option must be disabled like the above configurations. If both `restore_partitions` and `switch_profile`are enabled, both operations would not be executed.
- All partition images are verified with their md5sum files before switch_profile operation starts, no need to worry a currupted partition image.
- During switch profile operation, both the blue LED and the red LED would be blinking.

