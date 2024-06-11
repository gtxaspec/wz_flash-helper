#!/bin/sh

mkdir -p /extracted_firmware
cd /extracted_firmware

msg_color_bold white "> Extracting partition images from firmware image"

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "thingino_${chip_group}_boot.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=0 count=256 of=thingino_${chip_group}_boot.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum thingino_${chip_group}_boot.bin > thingino_${chip_group}_boot.bin.sha256sum

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "thingino_${chip_group}_env.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=256 count=64 of=thingino_${chip_group}_env.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum thingino_${chip_group}_env.bin > thingino_${chip_group}_env.bin.sha256sum

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "thingino_${chip_group}_ota.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=320 count=16064 of=thingino_${chip_group}_ota.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum thingino_${chip_group}_ota.bin > thingino_${chip_group}_ota.bin.sha256sum
