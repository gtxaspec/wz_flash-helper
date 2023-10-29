#!/bin/sh
#
#
#

emulate_mode="yes"

function init_emulate() {
# Description: Emulate various supposed-to-be automatically detected variables.
# For testing, only!
	dry_run="yes" # Override config file option so nothing is actually done

	chip_family="t31"
	flash_type="nor"
	current_profile="openipc"
	next_profile="stock"
	switch_profile="yes"

	msg
	msg "### Emulation mode is enabled, these variables are forged:"
	msg "### - Hardware: chip_family: $chip_family, flash_type: $flash_type"
	msg "### - Profiles: current_profile: $current_profile, next_profile: $next_profile, switch_profile: $switch_profile"
	msg "### Dry run is forcibly Enabled. No modification will be made."
	msg
}

[[ "$emulate_mode" == "yes" ]] && init_emulate
