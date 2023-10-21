#!/bin/bash
#
# Description: This script calculates start addresses of each partition given their sizes
# It is useful to write partitions to correct addresses in a new firmware with different mtd mapping without changing kernel cmdline
#

function addr_dec_1K_to_hex() {
# Syntax addr_dec_1K_to_hex <address in decimal, 1K block>
	dec_addr_1K="$1"
	printf '%x' $(( ${dec_addr_1K} * 1024 ))
}


function make_a_table() {
	part_count_total=$(( "${#part_name[@]}" - 1 ))

	echo -e "PART,SIZE(dec),START(dec),START(hex)"
	for part_num in $(seq 0 ${part_count_total});do
	#	echo "${part_name[${part_num}]}" "${part_size[${part_num}]}"
		part_start=0
		part_num_new=$(( ${part_num} - 1)) # Do this because array counts from 0
		for part_count_start_add in $(seq 0 ${part_num_new}); do
			part_start_add="${part_size[${part_count_start_add}]}"
			part_start=$(( ${part_start} + ${part_start_add} ))
		done
	echo -e "${part_name[${part_num}]},${part_size[${part_num}]},${part_start},0x$(addr_dec_1K_to_hex ${part_start})"
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

function import_vars_t20_openipc() {
	## Pan v1, v2
	part_name=(boot env kernel rootfs rootfs-data)
	part_size=(256 64 3072 10240 2752)
}

function import_vars_t31_openipc() {
	## Pan v2, v3, Floodlight
	part_name=(boot env kernel rootfs rootfs-data)
	part_size=(256 64 3072 10240 2752)
}

echo "---------- T20 stock ----------"
import_vars_t20_stock
make_a_table > /tmp/t20_stock_addresses
column -s, -t < /tmp/t20_stock_addresses
rm /tmp/t20_stock_addresses

echo
echo "---------- T31 stock ----------"
import_vars_t31_stock
make_a_table > /tmp/t31_stock_addresses
column -s, -t < /tmp/t31_stock_addresses
rm /tmp/t31_stock_addresses


echo
echo "---------- T20 OpenIPC ----------"
import_vars_t20_openipc
make_a_table > /tmp/t20_openipc_addresses
column -s, -t < /tmp/t20_openipc_addresses
rm /tmp/t20_openipc_addresses


echo
echo "---------- T31 OpenIPC ----------"
import_vars_t31_openipc
make_a_table > /tmp/t31_openipc_addresses
column -s, -t < /tmp/t31_openipc_addresses
rm /tmp/t31_openipc_addresses
