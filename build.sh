#!/bin/sh
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

function get_sdcard_kernel_filename() {
	local SoC="${1}"
	case ${SoC} in
		"t20")
			echo -n "factory_ZMC6tiIDQN"
			;;
		"t31")
			echo -n "factory_t31_ZMC6tiIDQN"
			;;
	esac
}

function get_default_kernel_config() {
	local SoC="${1}"
	case ${SoC} in
		"t20")
			echo -n "firmware/br-ext-chip-ingenic/board/t21/kernel/t20.generic.config"
			;;
		"t31")
			echo -n "firmware/br-ext-chip-ingenic/board/t31/kernel/t31.generic.config"
			;;
	esac
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

function patch_all_kernel_config() {
	for patch_SoC in ${all_SoCs}; do
		local default_kernel_config=$(get_default_kernel_config ${patch_SoC})
		
		if [ ! -f ${default_kernel_config}.bak ]; then
			cp ${default_kernel_config} ${default_kernel_config}.bak
			patch ${default_kernel_config} < kernel/kernel.patch.${patch_SoC}
		fi
	done
}

function make_kernel() {
	patch_all_kernel_config
	make_initramfs
	
	echo "[build.sh] Compiling kernel for ${SoC}"
	( cd firmware && BOARD=${SoC}_ultimate_defconfig make br-linux )

	mkdir -p output/${SoC}
	cp firmware/output/images/uImage output/${SoC}/${sdcard_kernel_filename}
	echo "[build.sh] Compiled kernel has been saved at output/${SoC}/${sdcard_kernel_filename}"
}

function make_release() {
	make_kernel
	
	echo "[build.sh] Making release for ${SoC}"
	
	cp -r wz_flash-helper output/${SoC}
	mv output/${SoC}/wz_flash-helper/restore/stock.conf.${SoC} output/${SoC}/wz_flash-helper/restore/stock.conf
	rm output/${SoC}/wz_flash-helper/restore/stock.conf.*
	
	mv output/${SoC}/wz_flash-helper/restore/openipc/openipc_env.bin.${SoC} output/${SoC}/wz_flash-helper/restore/openipc/openipc_${SoC}_env.bin
	rm output/${SoC}/wz_flash-helper/restore/openipc/openipc_env.bin.*
	
	( cd output/${SoC} && zip -r ${version}_${SoC}.zip . -x *.gitkeep)
	rm -r output/${SoC}/wz_flash-helper
}

function clean_up() {
	[ -d output ] && rm -r output
	[ -f /tmp/initramfs.cpio ] && rm /tmp/initramfs.cpio
	exit 0
}


sdcard_kernel_filename=$(get_sdcard_kernel_filename ${SoC})
version=$(cat initramfs_root/version)
all_SoCs="t20 t31"

mkdir -p output


[[ ${SoC} == "" ]] && [[ "${action}" == "clean" ]] && { clean_up ; exit 0 ; }
[[ ${SoC} == "" ]] && [[ "${action}" == "patch" ]] && { patch_all_kernel_config ; exit 0 ; }
echo "${all_SoCs}" | grep -q ${SoC} || { echo "[build.sh] Unsupported SoC" ; show_syntax ; }

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

