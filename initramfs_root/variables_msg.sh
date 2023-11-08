#!/bin/sh
#
# Description: These messages are used by init script, writing them on a separate file makes it look clean.
#

msg_rename_prog_sdcard_kernel_fail="WARNING!!! The program SD card kernel can not be renamed, this will result in a bootloop"

msg_dry_run_yes="Dry run mode is Active. Your partitions will not be modified"
msg_dry_run_no="WARNING!!! Dry run mode is Inactive. Your partitions might be modified, depending on your configuration. Stay safe!"

msg_backup_partitions_yes="[x] backup_partition value is Yes"
msg_backup_partitions_no="[ ] backup_partition value is No"
msg_backup_partitions_fail="Backup operation has failed, exiting..."
msg_backup_partitions_succeed="Backup operation was successful"

msg_restore_partitions_yes="[x] restore_partition value is Yes"
msg_restore_partitions_no="[ ] restore_partitions value is No"
msg_restore_partitions_fail="Restore operation has failed, exiting..."
msg_restore_partitions_succeed="Restore operation was successful"

msg_switch_profile_yes="[x] switch_profile value is Yes"
msg_switch_profile_no="[ ] switch_profile value is No"
msg_switch_profile_fail="Switch profile operation has failed, exiting..."
msg_switch_profile_succeed="Switch profile operation was successful"

msg_copy_new_sdcard_kernel_yes="[x] copy_new_sdcard_kernel value is Yes"
msg_copy_new_sdcard_kernel_no="[ ] copy_new_sdcard_kernel value is No"

msg_enable_custom_scripts_yes="[x] enable_custom_scripts value is Yes"
msg_enable_custom_scripts_no="[ ] enable_custom_scripts value is No"
msg_enable_custom_scripts_fail="Running custom scripts has failed, exiting..."
msg_enable_custom_scripts_succeed="Running custom scripts was successful"

