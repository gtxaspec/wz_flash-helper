[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md) | **Changelog**



## v0.6.0

- First official release

## v0.6.1

- Fix partition validation messages are not displayed correctly
- Add check for audio kernel module before playing audio

## v0.6.2

- Fix some messages are not displayed with colors
- Add wzmini profile

## v0.6.3

- Allow most special characters to be set for Wi-Fi password

## v0.6.4

- Print chip group info on serial terminal and to log files

## v0.6.5

- Grow wzmini kernel partition from 1984k to 3072k

## v0.6.6

- Improve displayed messages for profile detection

## v0.6.7

- Fix audio is not played on Wyze Pan v2
- Fix "Rebooting now" audio is not played

## v0.7.0

- Add more audio files to help the user better keep track of the operations

## v0.7.1

- Add a Powershell script to generate .sha256sum files to make Windows users happy

## v0.7.2

- Minor fixes

## v0.7.3

- Add emulation for chip name

## v0.7.4

- Add mising error checks for some functions
- Fix boot partition on NAND flash might not be backup correctly
- Add audio play for init fails

## v0.7.5

- Add colors to copy new sdcard kernel script 
- Fix written partition validation on NAND flash
- Before writing partition image, erase the partition first
- Remove partition image padding before writing it on NAND flash
- Fix dry_run is not enforced on emulation mode

## v0.7.6

- Remove ext2,ext3,ext4 kernel modules and minimalize busybox for smaller program size
- Use a single fw_printenv binary to slightly reduce program size
- Now the program contains only neccessary files for the SoC that it supports in each program kernel file

## v0.7.7

- Add option debug_manual_current_profile to set current_profile manually in case profile detection fails