#!/bin/sh
#
# Description: Detect camera model by reading the uboot devicemodel variable
#

function detect_model() {
	model=$(fw_printenv devicemodel | sed 's/devicemodel=//')

}

detect_model || return 1
