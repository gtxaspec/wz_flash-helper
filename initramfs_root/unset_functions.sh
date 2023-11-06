#!/bin/sh
#
# Description: unset functions to avoid name collision with functions in custom scripts
#

functionunset_functions() {
	### init script
	# unset msg
	# unset msg_dry_run
	# unset msg_nonewline
	# unset play_audio
	unset detect_hardware
	unset source_variables_init_msg
	# unset source_functions_io
	unset load_kernel_modules
	unset source_initialize_gpio
	unset welcome
	# unset wait_init_interrupt
	unset backup_bootpart
	unset source_detect_profile
	unset source_variables_prog_info
	unset source_variables_emulate
	unset source_current_profile
	unset mount_sdcard
	unset rename_prog_sdcard_kernel
	unset import_prog_config_file
	unset source_detect_model
	unset display_info
	# unset exit_init
	# unset main_init


	### operation_backup.sh script
	unset -f backup_entire_flash
	unset -f backup_parts
	unset -f archive_parts
	unset -f operation_backup

	### operation_restore.sh script
	unset -f restore_current_profile_bootpart
	unset -f restore_current_profile_parts
	unset -f operation_restore

	### operation_switch_profile.sh script
	unset -f validate_restore_partition_images
	unset -f validate_written_bootpart
	unset -f rollback_bootpart
	unset -f operation_switch_profile

	### action_copy_new_sdcard_kernel.sh script
	unset -f copy_new_sdcard_kernel
	
	### LEDs scripts
	unset -f blink_led_blue
	unset -f blink_led_red
	unset -f blink_led_red_and_blue
	unset -f turn_off_leds
	
	### Profile detection script
	unset -f detect_chip_group
	unset -f detect_profile
}

unset_functions
