#!/bin/sh

mkdir -p /extracted_firmware
cd /extracted_firmware

msg_color_bold white "> Extracting partition images from firmware image"

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "stock_${chip_group}_boot.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=0 count=256 of=stock_${chip_group}_boot.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum stock_${chip_group}_boot.bin > stock_${chip_group}_boot.bin.sha256sum

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "stock_${chip_group}_kernel.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_bs filename=1k skip=256 count=1984 of=stock_${chip_group}_kernel.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum stock_${chip_group}_kernel.bin > stock_${chip_group}_kernel.bin.sha256sum

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "stock_${chip_group}_rootfs.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=2240 count=3904 of=stock_${chip_group}_rootfs.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum stock_${chip_group}_rootfs.bin > stock_${chip_group}_rootfs.bin.sha256sum

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "stock_${chip_group}_app.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=6144 count=3904 of=stock_${chip_group}_app.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum stock_${chip_group}_app.bin > stock_${chip_group}_app.bin.sha256sum

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "stock_${chip_group}_kback.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=10048 count=1984 of=stock_${chip_group}_kback.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum stock_${chip_group}_kback.bin > stock_${chip_group}_kback.bin.sha256sum

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "stock_${chip_group}_aback.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=12032 count=3904 of=stock_${chip_group}_aback.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum stock_${chip_group}_aback.bin > stock_${chip_group}_aback.bin.sha256sum

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "stock_${chip_group}_cfg.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=15936 count=384 of=stock_${chip_group}_cfg.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum stock_${chip_group}_cfg.bin > stock_${chip_group}_cfg.bin.sha256sum

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "stock_${chip_group}_para.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=16320 count=64 of=stock_${chip_group}_para.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum stock_${chip_group}_para.bin > stock_${chip_group}_para.bin.sha256sum
