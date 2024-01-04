[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch firmware](README_switch_firmware.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md) | **Changelog** | [Limitation](Limitation.md)



## v0.9.0

> Note: This version configuration file is incompatible with older versions

- Change "switch profile" to "switch firmware"
- Remove emulation

## v0.8.7

- Add check and fix for Custom scripts that contain Windows Line Ending

## v0.8.6

- Improve coding style
- Allow booting a custom SD card kernel on the next boot after switching firmware

## v0.8.5

- Fix busybox ash double quote comparison quirk for Wi-Fi SSID and password
- Add an option to skip renaming program SD card kernel

## v0.8.4

- Improve coding style
- Improve `setup_openipc_env.sh`, add setting `devicemodel` to the script
- Allow executing init on manual mode

## v0.8.3

- Fix Wi-Fi vendor file path randomly changes
- Add error check for model detection fail on OpenIPC

## v0.8.2

- Fix LEDs don't stop blinking after operations fail
- Fix copying log files to SD card shown as successful even it fails
- Make copying new SD card kernel skip instead of fail if its prerequisites are not met

## v0.8.1

- Make setting Wi-Fi password with special characters easier
- Allow accessing initramfs shell before GPIO pins are initialized and kernel modules are loaded

## v0.8.0

- Add post-switch firmware script to set `devicemodel` variable
- Include `lsof` with busybox
- Fix Wi-Fi module vendor ID can't be read from OpenIPC
- Allow executing multiple gpio and kmod scripts 

## v0.7.9

- Fix boot partition restore
- Change OpenIPC uboot string for firmware detection

## v0.7.8

- Add manual_current_firmware and manual_model options
- Add command shortcuts `ms` and `us` for mounting and umounting SD card from initramfs shell

## v0.7.7

- Add /etc/profile and make initramfs shell login shell
- Remove vi from busybox
- Add color highlighting for nano
- Make initramfs shell prettier
- Fix Wi-Fi driver detection still runs even it is set on OpenIPC

## v0.7.6

- Remove ext2,ext3,ext4 kernel modules and minimalize busybox for smaller program size
- Use a single fw_printenv binary to slightly reduce program size
- Now the program contains only neccessary files for the SoC that it supports in each program kernel file

## v0.7.5

- Add colors to copy new sdcard kernel script 
- Fix written partition validation on NAND flash
- Before writing partition image, erase the partition first
- Remove partition image padding before writing it on NAND flash
- Fix dry_run is not enforced on emulation mode

## v0.7.4

- Add mising error checks for some functions
- Fix boot partition on NAND flash might not be backup correctly
- Add audio play for init fails

## v0.7.3

- Add emulation for chip name

## v0.7.2

- Minor fixes

## v0.7.1

- Add a Powershell script to generate .sha256sum files to make Windows users happy

## v0.7.0

- Add more audio files to help the user better keep track of the operations

## v0.6.7

- Fix audio is not played on Wyze Pan v2
- Fix "Rebooting now" audio is not played

## v0.6.6

- Improve displayed messages for firmware detection

## v0.6.5

- Grow wzmini kernel partition from 1984k to 3072k

## v0.6.4

- Print chip group info on serial terminal and to log files

## v0.6.3

- Allow most special characters to be set for Wi-Fi password

## v0.6.2

- Fix some messages are not displayed with colors
- Add wzmini firmware

## v0.6.1

- Fix partition validation messages are not displayed correctly
- Add check for audio kernel module before playing audio

## v0.6.0

- First official release
