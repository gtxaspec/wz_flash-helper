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
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=256 count=2048 of=stock_${chip_group}_kernel.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum stock_${chip_group}_kernel.bin > stock_${chip_group}_kernel.bin.sha256sum

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "stock_${chip_group}_root.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=2304 count=3392 of=stock_${chip_group}_root.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum stock_${chip_group}_root.bin > stock_${chip_group}_root.bin.sha256sum

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "stock_${chip_group}_driver.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=5696 count=640 of=stock_${chip_group}_driver.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum stock_${chip_group}_driver.bin > stock_${chip_group}_driver.bin.sha256sum

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "stock_${chip_group}_appfs.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=6336 count=4736 of=stock_${chip_group}_appfs.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum stock_${chip_group}_appfs.bin > stock_${chip_group}_appfs.bin.sha256sum

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "stock_${chip_group}_backupk.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=11072 count=2048 of=stock_${chip_group}_backupk.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum stock_${chip_group}_backupk.bin > stock_${chip_group}_backupk.bin.sha256sum

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "stock_${chip_group}_backupd.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=13120 count=640 of=stock_${chip_group}_backupd.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum stock_${chip_group}_backupd.bin > stock_${chip_group}_backupd.bin.sha256sum

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "stock_${chip_group}_backupa.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=13760 count=2048 of=stock_${chip_group}_backupa.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum stock_${chip_group}_backupa.bin > stock_${chip_group}_backupa.bin.sha256sum

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "stock_${chip_group}_config.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=15808 count=256 of=stock_${chip_group}_config.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum stock_${chip_group}_config.bin > stock_${chip_group}_config.bin.sha256sum

msg_color_nonewline white "    Extracting "
msg_color_nonewline cyan "stock_${chip_group}_para.bin"
msg_color_nonewline white "... "
dd if=$nf_images_path/$nf_firmware_filename bs=1k skip=16064 count=256 of=stock_${chip_group}_para.bin && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
sha256sum stock_${chip_group}_para.bin > stock_${chip_group}_para.bin.sha256sum
