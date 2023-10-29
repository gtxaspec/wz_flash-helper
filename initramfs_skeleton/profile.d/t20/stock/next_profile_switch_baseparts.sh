#!/bin/sh
#
# Description: This script returns tasks of the queried partition that need to be done on a minimal working firmware
#

function get_next_profile_switch() {
# Description: Return task will be done with queried partition when switching firmware
# Syntax: get_next_profile_switch <partname>
	case "$1" in
		"boot")
			echo -n "[write]" ;;
		"[partnameA]")
			echo -n "[format]" ;;
		"[partnameB]")
			echo -n "[erase]" ;;
		"[partnameC]")
			echo -n "[leave]" ;;
	esac
}

