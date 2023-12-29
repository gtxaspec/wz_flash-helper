#!/bin/sh
#
# Description: Load jzmmc driver
#

insmod /kernel_module.d/modules/jzmmc_v12.ko cd_gpio_pin=62
sleep 1
