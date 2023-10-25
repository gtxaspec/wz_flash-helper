#!/bin/sh




dry_run_yes="Dry run mode is Active. Your partitions will not be modified"
dry_run_no="WARNING!!! Dry run mode is Inactive. Your partitions might be modified, depends on your configuration. Stay safe!"

backup_partitions_yes="backup_partition value is Yes"
backup_partitions_no="backup_partition value is No"
backup_partitions_fail="Backup operation failed, exiting..."
backup_partitions_succeed="Backup operation succeeded"

restore_partitions_yes="restore_partition value is Yes"
restore_partitions_no="restore_partitions value is No"
restore_partitions_fail="Restore operation failed, exiting..."
backup_partitions_succeed="Restore operation succeeded"

switch_fw_yes="switch_fw value is Yes"
switch_fw_no="switch_fw value is No"
switch_fw_fail="Switch firmware operation failed, exiting..."
switch_fw_succeed="Switch firmware operation succeeded"

enable_custom_script_yes="enable_custom_script value is Yes"
enable_custom_script_no="enable_custom_script value is No"
enable_custom_script_fail="Custom script running failed, exiting..."
enable_custom_script_succeed="Custom script running succeeded"

enable_continue_boot_img_yes="enable_continue_boot_img value is Yes"
enable_continue_boot_img_no="enable_continue_boot_img value is No"
enable_continue_boot_img_fail="Moving continue boot image failed, exiting..."
enable_continue_boot_img_succeed="Moving continue boot image succeeded"
