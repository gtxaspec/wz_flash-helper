#!/bin/sh




t20_openipc_valid_hashes=""

t31_openipc_valid_hashes=""


function get_new_boot_part_hash() {
# Description: Return md5 hash of current boot partition
	dd if=$boot_partmtd of=/boot_part_new.img

	local new_boot_part_md5=$(md5sum /boot_part_new.img)
	rm /boot_part_new.img
	echo -n "$boot_partimg_md5_new"
}

validate_openipc_boot() {
# Description: Check if flashed OpenIPC boot partition hash is on the valid hash list
	case "$chip_family" in
		"t20") openipc_valid_boot_hash_list="$t20_valid_hashes" ;;
		"t31") openipc_valid_boot_hash_list="$t31_valid_hashes" ;;
	esac
	
	local new_boot_part_md5=$(get_new_boot_part_hash)
	if echo "$openipc_valid_boot_hash_list" | grep -q $new_boot_part_md5 ; then
		return 0
	else
		msg "md5 check for valid OpenIPC boot partition failed"
	fi
	
	get_boot_part_hash
	if ! echo "$openipc_valid_boot_hash_list" | grep -q $new_boot_part_md5 ; then
		msg "md5 check for valid OpenIPC boot partition failed second time"
	else
		return 0
	fi
	
	get_boot_part_hash
	if ! echo "$openipc_valid_boot_hash_list" | grep -q $new_boot_part_md5 ; then
		{ msg "md5 check for valid OpenIPC boot partition failed third time" ; return 1 ; }
	else
		return 0
	fi
}

validate_openipc_boot || return 1
