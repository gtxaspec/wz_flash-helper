#!/bin/sh
#
# Description: Detect camera model by reading the uboot devicemodel variable
#

function detect_model() {
	model=$(fw_printenv devicemodel | sed 's/devicemodel=//')
	if [[ -z "$model" ]]; then
		msg_color red "Unable to detect camera model by reading devicemodel env variable"
		return 1
	fi
}

detect_model || return 1
