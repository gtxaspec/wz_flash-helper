#!/bin/sh
#
# Description: These messages are used by init script, writing them on a separate file makes it look clean.
#

dry_run_yes="Dry run mode is Active. Your partitions will not be modified"
dry_run_no="WARNING!!! Dry run mode is Inactive. Your partitions might be modified, depends on your configuration. Stay safe!"

backup_partitions_yes="backup_partition value is Yes"
backup_partitions_no="backup_partition value is No"
backup_partitions_fail="Backup operation failed, exiting..."
backup_partitions_succeed="Backup operation succeeded"

restore_partitions_yes="restore_partition value is Yes"
restore_partitions_no="restore_partitions value is No"
restore_partitions_fail="Restore operation failed, exiting..."
restore_partitions_succeed="Restore operation succeeded"

switch_profile_yes="switch_profile value is Yes"
switch_profile_no="switch_profile value is No"
switch_profile_fail="Switch profile operation failed, exiting..."
switch_profile_succeed="Switch profile operation succeeded"

enable_custom_script_yes="enable_custom_script value is Yes"
enable_custom_script_no="enable_custom_script value is No"
enable_custom_script_fail="Custom script running failed, exiting..."
enable_custom_script_succeed="Custom script running succeeded"

copy_new_sdcard_bootimg_yes="enable_continue_boot_img value is Yes"
copy_new_sdcard_bootimg_no="enable_continue_boot_img value is No"
copy_new_sdcard_bootimg_fail="Moving continue boot image failed, exiting..."
copy_new_sdcard_bootimg_succeed="Moving continue boot image succeeded"