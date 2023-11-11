#!/bin/bash
#
# Description: This script calculates start addresses and MTD mapping of partitions given only their sizes
# It is used to map partitions in a different firmware which has different mtd mapping by changing kernel cmdline
#

function addr_dec_1K_to_hex() {
# Syntax addr_dec_1K_to_hex <address in decimal, 1K block>
# Return: address in hexadecimal
	dec_addr_1K="$1"
	printf '%x' $(( ${dec_addr_1K} * 1024 ))
}

function make_a_table() {
	local devname="$1"
	local part_count_total=$(( "${#part_name[@]}" - 1 ))

	echo -e "PART,SIZE(dec),START(dec),START(hex),MTD MAPPING"
	for part_num in $(seq 0 ${part_count_total}); do
		# echo "${part_name[${part_num}]}" "${part_size[${part_num}]}"
		local part_start=0
		local part_num_new=$(( ${part_num} - 1 )) # Do this because array counts from 0
		for part_count_start_add in $(seq 0 ${part_num_new}); do
			part_start_add="${part_size[${part_count_start_add}]}"
			part_start=$(( ${part_start} + ${part_start_add} ))
		done

	local PART="${part_name[${part_num}]}"
	local SIZE_DEC="${part_size[${part_num}]}"
	local START_DEC="${part_start}"
	local START_HEX="0x$(addr_dec_1K_to_hex ${part_start})"

	local MTD_SIZE="${SIZE_DEC}K"
	local MTD_START="${START_DEC}K"
	[[ "${MTD_START}" == "0K" ]] && MTD_START="0"

	local MTD_PART="${devname}_${PART}"
	[[ "${PART}" == "boot" ]] && MTD_PART="boot"

	local MTD_MAPPING="${MTD_SIZE}@${MTD_START}(${MTD_PART})"

	echo -e "${PART},${SIZE_DEC},${START_DEC},${START_HEX},${MTD_MAPPING}"


	done
}

function import_vars_t20_stock() {
	## Pan v1, v2
	part_name=(boot kernel root driver appfs backupk backupd backupa config para)
	part_size=(256 2048 3392 640 4736 2048 640 2048 256 256)
}

function import_vars_t31_stock() {
	## Pan v2, v3, Floodlight
	part_name=(boot kernel rootfs app kback aback cfg para)
	part_size=(256 1984 3904 3904 1984 3904 384 64)
}

function import_vars_wzmini() {
	part_name=(boot kernel rootfs configs)
	part_size=(256 1984 13760 384)
}

function import_vars_openipc() {
	part_name=(boot env kernel rootfs rootfs-data)
	part_size=(256 64 3072 10240 2752)
}



echo
echo "---------- OpenIPC ----------"
import_vars_openipc
make_a_table "openipc" > /tmp/openipc_addresses
column -s, -t < /tmp/openipc_addresses
echo
echo "mtdparts: $(cat /tmp/openipc_addresses | cut -d ',' -f5 | tail -n +2 | tr '\n' ',' | sed 's/.$//')"
rm /tmp/openipc_addresses

echo
echo "---------- T20 stock ----------"
import_vars_t20_stock
make_a_table "stock" > /tmp/t20_stock_addresses
column -s, -t < /tmp/t20_stock_addresses
echo
echo "mtdparts: $(cat /tmp/t20_stock_addresses | cut -d ',' -f5 | tail -n +2 | tr '\n' ',' | sed 's/.$//')"
rm /tmp/t20_stock_addresses

echo
echo "---------- T31 stock ----------"
import_vars_t31_stock
make_a_table "stock" > /tmp/t31_stock_addresses
column -s, -t < /tmp/t31_stock_addresses
echo
echo "mtdparts: $(cat /tmp/t31_stock_addresses | cut -d ',' -f5 | tail -n +2 | tr '\n' ',' | sed 's/.$//')"
rm /tmp/t31_stock_addresses

echo
echo "---------- wzmini ----------"
import_vars_wzmini
make_a_table "wzmini" > /tmp/wzmini_addresses
column -s, -t < /tmp/wzmini_addresses
echo
echo "mtdparts: $(cat /tmp/wzmini_addresses | cut -d ',' -f5 | tail -n +2 | tr '\n' ',' | sed 's/.$//')"
rm /tmp/wzmini_addresses



