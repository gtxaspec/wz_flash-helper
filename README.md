## Still under development, you can not use this yet until there is a release

# wz_flash-helper
Automatic parttion backup/restore tool for T20/T31 cameras, works with both stock and OpenIPC firmware.

You can also switch between stock and OpenIPC firmware without a scratch

## Supported cameras
- Wyze Cam Pan
- Wyze Cam v2
- Wyze Cam v2 Pan
- Wyze Cam v3
- Wyze Cam Floodlight

## Feature list
- No serial connection or SSH is needed! only SD card.
- Custom script to run after backup/restore.
- Dry run option for safety and debugging.
- Seamless transition to a new boot image on SD card after backup/restore.
- Initramfs shell for manual debugging is available if you have a serial connection.

## How to backup your stock partitions - Read this if this is your first use
1. Download [lastest release](https://github.com/archandanime/wz_flash-helper/releases/latest) then extract the `wz_flash-helper` directory and `factory_t31_ZMC6tiIDQN` to your SD card.
2. Edit the config file `wz_flash-helper.conf` with:
```
dry_run="yes"
backup_partitions="yes"
restore_partitions="no"
restore_fw_type="stock"
custom_script=""
```
3. Insert your SD card and power on your camera.
4. Wait for the camera to restart after wcv3_flasher-helper finishes its operations. Then turn the off camera, remove your SD card, and check `wz_flash-helper.log` on your SD card to see if everything looks fine and there is no error.
5. Edit `wz_flash-helper.conf` same as Step 1, but with the `dry_run` option turned off.
6. Do Steps 3 and 4 again, then check your SD card, there should be a `wz_flash-helper/backup/stock` directory where backups of your stock partitions are stored. Copy it to a safe place in case you need it for recovery.

## How to restore partitions
1. Download [lastest release](https://github.com/archandanime/wz_flash-helper/releases/latest) then extract the `wz_flash-helper` directory and `factory_t31_ZMC6tiIDQN` to your SD card.
2. Edit `wz_flash-helper.conf` to select the firmware type that you want to restore("stock" or "openipc")
3. Edit `wz_flash-helper.conf` to select partitions to be restored. If you are switching between stock and OpenIPC firmware, enable restore options for all partitions of the corresponding firmware type.
4. Insert your SD card into your camera and reboot.

## Run a custom script
You can write a script and specify it in the `wz_flash-helper.conf` file with the `custom_script` option. This script will be executed after backup/restore operations are finished. This is useful if you want to write your configuration files into writable partition(s).

## Specify the boot image on the SD card that will be used on the next boot
If you are using wz_mini_hacks with stock firmware, you can rename wz_mini's boot image to `factory_t31_ZMC6tiIDQN.wz_mini` and specify that file name with the `continue_boot_img_filename` option. After wz_flash-helper finishes its operations, this file will be renamed to `factory_t31_ZMC6tiIDQN` to allow this boot image to be booted on the next boot without having to pull the SD card and rename it manually. Seamless transition!

**Notes:**
- You need md5sum files of the partition images that you want to restore in `<partition name>.ms5sum` format. Backup operations will automatically generate md5sum files.
- It is highly recommended to enable `dry_run` to check if everything works before doing real operations.
- Backup is done first, then Restore and followed by Custom script.
- Custom script is not run if `dry_run` is set to `yes`.
- Custom script does not necessarily have to be on the SD Card top directory, you can put its path on the option to make it run from somewhere else.
- During backup operations, the blue LED would be blinking. During restore operations, the red LED would be blinking.

## Warning
```
I am not responsible for bricking someone's camera.
Though it has been tested carefully, the bootloader partition won't ever be touched.
It is still possible to hardbrick the camera with your custom script or command injection in the config file.
Dry run first is highly recommended, unless you are confident.
```

## Credits
- Gtxaspec with his ideas, tips and hard work on OpenIPC drivers.
- Mnakada with their docker image to build the boot image from [their repo](https://github.com/mnakada/atomcam_tools)
