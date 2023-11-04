#!/bin/sh
#
# Description: Load audio driver for Pan Cam v2 with speaker GPIO parameter
#

function load_kmod_pan_cam_v2() {
	if fw_printenv wlandev | grep -q "atbm603x-t31-wyze-pan-v2" || grep -q "recovery_wcpv2.bin" /bootpart_backup.img.strings ; then
		insmod /kernel_module.d/t31/t31_audio.ko spk_gpio=7
		kmod_speciality_flag="true"
	fi
}

load_kmod_pan_cam_v2
