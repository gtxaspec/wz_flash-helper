#!/bin/sh
#
# Description: Detect camera model by reading automatic generated file from factory
#

function detect_model_cleanup() {
	umount $mnt_config && rmdir $mnt_config
}

function detect_model() {
	local config_partname="cfg"
	local model_config_file=".product_config"

	local partmtdblock=$(get_cp_partmtdblock $config_partname)
	local partfstype=$(get_cp_partfstype $config_partname)
	local mnt_config="/mnt_${config_partname}"

	mkdir $mnt_config
	mount -o ro -t $partfstype $partmtdblock $mnt_config

	if cat $mnt_config/$model_config_file | grep -q "WYZE_CAKP2JFUS" ; then
		model="v3"

	elif cat $mnt_config/$model_config_file | grep -q "HL_PAN2" ; then
		model="pan_v2"

	elif cat $mnt_config/$model_config_file | grep -q "WYZEC1-JZ" ; then
		model="v3c"

	else
		model="unknown"
		msg_color red "Unable to detect camera model by reading stock partition config file"
		detect_model_cleanup
		return 1
	fi

	detect_model_cleanup
}

detect_model || return 1
