#!/bin/sh
#
# Description: Load audio driver for Pan Cam v2 with speaker GPIO parameter
#

load_kmod_pan_cam_v2() {
	if fw_printenv wlandev | grep -q "atbm603x-t31-wyze-pan-v2"; then
		insmod /kernel_module.d/t31/t31_audio.ko spk_gpio=7
		kmod_speciality_flag="true"
	fi
}

load_kmod_pan_cam_v2
