#!/bin/sh
#
# Description: Detect camera model by reading the uboot devicemodel variable
#

function detect_model() {
	model=$(fw_printenv devicemodel | sed 's/devicemodel=//')
	[[ -z "$model" ]] && { msg_color red "Unable to detect camera model by reading devicemodel env variable" ; return 1 ; }
}

detect_model || return 1
