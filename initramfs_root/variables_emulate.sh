#!/bin/sh
#
# Description: Emulate various supposed-to-be automatically detected variables. For testing only!
#

emulate_mode="no"

function emulate() {
	enforce_dry_run="yes" # Override dry_run option so nothing is actually done

	#chip_name=""
	#chip_family=""
	#flash_type=""
	#current_profile=""

	msg
	msg_color_bold lightbrown "### Emulation mode is enabled; these variables are forged:"
	msg_color_bold lightbrown "### - Hardware: chip_name: $chip_name, chip_family: $chip_family, flash_type: $flash_type"
	msg_color_bold lightbrown "### - Current profile: $current_profile"
	msg_color_bold lightbrown "### Dry run is forcibly Enabled. No modification will be made."
	msg
}

[[ "$emulate_mode" == "yes" ]] && emulate
