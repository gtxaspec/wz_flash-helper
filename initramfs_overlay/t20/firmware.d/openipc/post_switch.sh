#!/bin/sh
#
# Description: This script is run after switch to this firmware
#

msg_nonewline "    Setting "
msg_color_nonewline cyan "devicemodel "
msg_nonewline "env variable... "
fw_setenv devicemodel $model && msg_color green "ok" || msg_color red "failed"
