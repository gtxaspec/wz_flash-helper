#!/bin/sh
#
# Description: Load audio driver
#

if fw_printenv wlandev | grep -q "atbm603x-t31-wyze-pan-v2" || grep -q "recovery_wcpv2.bin" /boot_backup.img.strings ; then
	insmod /kernel_module.d/modules/audio.ko spk_gpio=7
else
	insmod /kernel_module.d/modules/audio.ko
fi
