#!/bin/sh
#
# Description: This script is run after switch to this firmware
#

msg_nonewline "    Flipping off "
msg_color_nonewline cyan "switch_firmware "
msg_nonewline "option from general.conf... "

sed -i "s/switch_firmware=\"yes\"/switch_firmware=\"no\"/" $prog_config_file && msg_color green "ok" || msg_color red "failed"
