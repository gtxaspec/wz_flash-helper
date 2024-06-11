#!/bin/bash
#
#
#

action="${1}"
SoC="${2}"




function show_syntax() {
	echo "./build.sh <action> <SoC>"
	echo "Actions: initramfs kernel release clean"
	echo "SoCs: t20 t31"
	exit 1
}

function make_initramfs() {
	echo "[build.sh] Creating /tmp/initramfs.cpio"

	mkdir -p output/initramfs
	cp -r initramfs_root/* output/initramfs
	cp -r initramfs_overlay/${SoC}/* output/initramfs

	[ -f /tmp/initramfs.cpio ] && rm /tmp/initramfs.cpio
	( cd output/initramfs && find . | fakeroot cpio --create --format='newc' | gzip > /tmp/initramfs.cpio)

	rm -r output/initramfs
}

function patch_kernel_configs() {
	cd thingino-firmware
	for patch_SoC in ${all_SoCs}; do
		if ! patch -R -p1 -s -f --dry-run < ../patches/${patch_SoC}.patch ; then
  			patch -p1 < ../patches/${patch_SoC}.patch
		fi
	done
	cd ..
}

function make_kernel() {
	patch_kernel_configs
	make_initramfs

	echo "[build.sh] Compiling kernel for ${SoC}"
	( cd thingino-firmware && BOARD=${PROFILE} make br-linux-rebuild )

	mkdir -p output/${SoC}
	cp ${HOME}/output/wyze_c3_t31x_atbm/build/linux-*/arch/mips/boot/uImage  output/${SoC}/${sdcard_kernel_filename}
	echo
	echo "[build.sh] Compiled kernel has been saved at output/${SoC}/${sdcard_kernel_filename}"
}

function make_release() {
	make_kernel

	echo "[build.sh] Making release for ${SoC}"

	mkdir -p output/${SoC}
	cp $HOME/output/${PROFILE}/build/linux-*/arch/mips/boot/uImage output/${SoC}/${sdcard_kernel_filename}

	cp -r wz_flash-helper output/${SoC}
	cp -r wz_flash-helper_overlay/${SoC}/* output/${SoC}/wz_flash-helper

	( cd output/${SoC} && zip -r ${version}_${SoC}.zip . -x *.gitkeep)
	rm -r output/${SoC}/wz_flash-helper
	echo
	echo "[build.sh] Release zip file has been saved at output/${SoC}/${version}_${SoC}.zip"
}

function clean_up() {
	[ -d output ] && rm -r output
	[ -f /tmp/initramfs.cpio ] && rm /tmp/initramfs.cpio
	exit 0
}


version=$(cat initramfs_root/version)
all_SoCs="t20 t31"

mkdir -p output


[[ ${SoC} == "" ]] && [[ "${action}" == "clean" ]] && { clean_up ; exit 0 ; }
[[ ${SoC} == "" ]] && [[ "${action}" == "patch" ]] && { patch_kernel_configs ; exit 0 ; }
echo "${all_SoCs}" | grep -q ${SoC} || { echo "[build.sh] Unsupported SoC" ; show_syntax ; }


case ${SoC} in
	"t20")
		sdcard_kernel_filename="factory_ZMC6tiIDQN"
		PROFILE="wyze_c2_jxf22"
		;;
	"t31")
		sdcard_kernel_filename="factory_t31_ZMC6tiIDQN"
		PROFILE="wyze_c3_t31x_atbm"
		;;
esac

case ${action} in
	"initramfs")
		make_initramfs
		;;
	"kernel")
		make_kernel
		;;
	"release")
		make_release
		;;
	*)
		echo "[build.sh] Invalid action"
		show_syntax
		;;
esac

