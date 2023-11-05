#!/bin/sh
#
#
#

action="${1}"
SoC="${2}"




function show_syntax() {
	echo "./build.sh <action> [SoC]"
	echo "Actions: patch initramfs kernel release clean"
}

function get_sdcard_kernel_filename() {
	case ${SoC} in
		"t20")
			echo -n "factory_ZMC6tiIDQN"
			;;
		"t31")
			echo -n "factory_t31_ZMC6tiIDQN"
			;;
	esac
}

function make_initramfs() {
	( cd initramfs_root && find . | fakeroot cpio --create --format='newc' | gzip > /tmp/initramfs.cpio )
}

function patch_kernel_config() {
	patch firmware/br-ext-chip-ingenic/board/t21/kernel/t20.generic.config < kernel/kernel.patch.t20
	patch firmware/br-ext-chip-ingenic/board/t31/kernel/t31.generic.config < kernel/kernel.patch.t31
}

function compile_kernel() {
	echo "Make sure that you patched kernel config by running ./build.sh patch first!"
	echo
	sleep 2
	make_initramfs
	( cd firmware && BOARD=${SoC}_ultimate_defconfig make br-linux )

	mkdir -p output/${SoC}
	cp firmware/output/images/uImage output/${SoC}/${sdcard_kernel_filename}
}

function make_release() {
	mkdir -p output/${SoC}

        make_initramfs
	compile_kernel

	cp -r wz_flash-helper output/${SoC}
	mv output/${SoC}/wz_flash-helper/restore/stock_${SoC}.conf output/${SoC}/wz_flash-helper/restore/stock.conf
	rm output/${SoC}/wz_flash-helper/restore/stock_*.conf

	( cd output/${SoC} && zip -r ${version}_${SoC}.zip . -x *.gitkeep)
	rm -r output/${SoC}/wz_flash-helper
}

function clean_up() {
	[ -d output ] && rm -r output
	[ -f tmp/initramfs.cpio ] && rm /tmp/initramfs.cpio
	return 0
}


sdcard_kernel_filename=$(get_sdcard_kernel_filename ${SoC})
version=$(cat initramfs_root/version)

mkdir -p output

case ${action} in
	"patch")
		patch_kernel_config
		;;
	"initramfs")
		make_initramfs
		;;
	"kernel")
		compile_kernel
		;;
	"release")
		make_release
		;;
	"clean")
		clean_up
		;;
	*)
		show_syntax
		;;
esac

