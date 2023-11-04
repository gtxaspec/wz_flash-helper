#!/bin/sh
#
# Description: These messages are used by init script, writing them on a separate file makes it look clean.
#

rename_prog_sdcard_kernelimg_fail="WARNING!!! Program SD card kernel can not be renamed, this will result in a bootloop"

dry_run_yes="Dry run mode is Active. Your partitions will not be modified"
dry_run_no="WARNING!!! Dry run mode is Inactive. Your partitions might be modified, depends on your configuration. Stay safe!"

backup_partitions_yes="[x] backup_partition value is Yes"
backup_partitions_no="[ ] backup_partition value is No"
backup_partitions_fail="Backup operation failed, exiting..."
backup_partitions_succeed="Backup operation succeeded"

restore_partitions_yes="[x] restore_partition value is Yes"
restore_partitions_no="[ ] restore_partitions value is No"
restore_partitions_fail="Restore operation failed, exiting..."
restore_partitions_succeed="Restore operation succeeded"

switch_profile_yes="[x] switch_profile value is Yes"
switch_profile_no="[ ] switch_profile value is No"
switch_profile_fail="Switch profile operation failed, exiting..."
switch_profile_succeed="Switch profile operation succeeded"

enable_custom_script_yes="[x] enable_custom_script value is Yes"
enable_custom_script_no="[ ] enable_custom_script value is No"
enable_custom_script_fail="Custom script running failed, exiting..."
enable_custom_script_succeed="Custom script running succeeded"

copy_new_sdcard_kernelimg_yes="[x] copy_new_sdcard_kernelimg value is Yes"
copy_new_sdcard_kernelimg_no="[ ] copy_new_sdcard_kernelimg value is No"
copy_new_sdcard_kernelimg_fail="Copying continue kernel image failed, exiting..."
copy_new_sdcard_kernelimg_succeed="Copying new sdcard kernel image succeeded"
