#!/bin/sh
#
# Description: Emulate various supposed-to-be automatically detected variables
#              For testing, only!

emulate_mode="no"

function emulate() {
	dry_run="yes" # Override config file option so nothing is actually done

	chip_family=""
	flash_type=""
	current_profile=""

	msg
	msg "### Emulation mode is enabled, these variables are forged:"
	msg "### - Hardware: chip_family: $chip_family, flash_type: $flash_type"
	msg "### - Current profile: $current_profile"
	msg "### Dry run is forcibly Enabled. No modification will be made."
	msg
}

[[ "$emulate_mode" == "yes" ]] && emulate
