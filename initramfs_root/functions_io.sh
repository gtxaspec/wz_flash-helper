#!/bin/bash
#
#  ___ ___     __                  _   _                 
# |_ _/ _ \   / _|_   _ _ __   ___| |_(_) ___  _ __  ___ 
#  | | | | | | |_| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#  | | |_| | |  _| |_| | | | | (__| |_| | (_) | | | \__ \
# |___\___/  |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#


function backup_partition_nor() {
# Description: Dump partition <partmtd> contents to <outfile> on NOR flash
# Syntax: restore_partition_nor <partmtd> <outfile>
	local partmtd="$1"
	local outfile="$2"
	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "dd if=$partmtd of=$outfile"
	else
		msg_nonewline " + Reading... "
		dd if=$partmtd of=$outfile && msg "succeeded" || { msg "failed" ; return 1 ; } 
	fi
}

function backup_partition_nand() {
# Description: Dump partition <partmtd> contents to <outfile> on NAND flash
# Syntax: restore_partition_nand <partmtd> <outfile>
	local partmtd="$1"
	local outfile="$2"
	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "nanddump -f $outfile $partmtd"
	else
		msg_nonewline " + Reading... "
		nanddump -f $outfile $partmtd && msg "succeeded" || { msg "failed" ; return 1 ; } 
	fi
}

function backup_partition() {
# Description: Dump partition <partmtd> contents to <outfile>
# Syntax: backup_partition <partname> <partmtd> <outfile>
	local partname="$1"
	local partmtd="$2"
	local outfile="$3"
	
	msg "- Read from flash: $partname at $partmtd to file $outfile ---"
	[ -f $outfile ] && { msg " + $outfile already exists" ; return 1 ; }
	
	case "$flash_type" in
		"nor")
			backup_partition_nor $partmtd $outfile || return 1 ;;
		"nand")
			backup_partition_nand $partmtd $outfile || return 1 ;;
		*)
			msg " + Invalid flash type, are you on emulation mode?" ;;
	esac
	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "md5sum $outfile > $outfile.md5sum"
		msg_dry_run "local outfile_dir=$(dirname $outfile) && sed -i \"s|\$outfile_dir/||g\" $outfile.md5sum"
	else
		msg_nonewline " + Generating md5sum file... "
		md5sum $outfile > $outfile.md5sum && msg "succeeded" || { msg "failed" ; return 1 ; } 
		local outfile_dir=$(dirname $outfile) && sed -i "s|$outfile_dir/||g" $outfile.md5sum # Remove path of partition images files from their .md5sum files
	fi
}

function archive_partition() {
# Description: Create .tar.gz archive from partition <partmtdblock> files
# Syntax: archive_partition <partname> <partblockmtd> <fstype> <outfile>
	local partname="$1"
	local partblockmtd="$2"
	local fstype="$3"
	local outfile="$4"
	
	local archive_mnt_dir="/archive_mnt_$partname"
	mkdir -p $archive_mnt_dir
	
	msg "- Archive partition: $partname($partblockmtd) files to file $outfile ---"
	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "mount -o ro -t $fstype $partblockmtd $archive_mnt_dir"
		msg_dry_run "tar -czvf $outfile -C $archive_mnt_dir ."
		msg_dry_run "md5sum $outfile > $outfile.md5sum"
	else
		mount -o ro -t $fstype $partblockmtd $archive_mnt_dir || { msg "Failed to mount $partname" ; return 1 ; }
		msg_nonewline " + Creating archive file... "
		tar -czvf $outfile -C $archive_mnt_dir . && msg "succeeded" || { msg "failed" ; return 1 ; }
		msg_nonewline " + Generating md5sum file... "
		md5sum $outfile > $outfile.md5sum && msg "succeeded" || { msg "failed" ; return 1 ; } 
		umount $archive_mnt_dir && rmdir $archive_mnt_dir
	fi
	
	sync

}

function restore_partition_nor() {
# Description: Write to <partmtd> partition using <infile> on NOR flash
# Syntax: restore_partition_nor <infile> <partmtd>
	local infile="$1"
	local partmtd="$2"

	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "flashcp $infile $partmtd"
	else
		msg_nonewline " + Writing... "
		flashcp $infile $partmtd && msg "succeeded" || { msg "failed" ; return 1 ; } 
	fi
}

function restore_partition_nand() {
# Description: Write to <partmtd> partition using <infile> on NAND flash
# Syntax: restore_partition_nand <infile> <partmtd>
	local infile="$1"
	local partmtd="$2"
	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "nandwrite -p $partmtd $infile"
	else
		msg_nonewline " + Writing... "
		nandwrite -p $partmtd $infile || { msg "failed" ; return 1 ; } 
	fi
}

function restore_partition() {
# Description: Write to <partmtd> partition using <infile>, <infile> and its md5sum file will be copied to stage directory before proceed writing
# Syntax: restore_partition <partname> <restore_stage_dir> <infile> <partname>
	local partname="$1"
	local infile="$2"
	local partmtd="$3"

	local infile_name=$(basename $infile)
	local restore_stage_dir="/restore_stage_dir"
	

	msg "- Write to flash: file $infile_name to $partname($partmtd) ---"
	mkdir -p $restore_stage_dir
	cp $infile $restore_stage_dir/$infile_name || { msg " + $infile_name is missing" ; return 1 ; }
	cp $infile.md5sum $restore_stage_dir/$infile_name.md5sum || { msg " + $infile_name.md5sum is missing" ; return 1 ; }
	
	cd $restore_stage_dir
	if [[ "$dry_run" == "yes" ]]; then
		msg_nonewline " + Verifying $infile_name... "
		md5sum -c $infile_name.md5sum && msg "ok" || { msg "failed" ; return 1 ; }
	else
		msg_nonewline " + Verifying $infile_name... "
		md5sum -c $infile_name.md5sum && msg "ok" || { msg "failed" ; return 1 ; }
	fi

	case "$flash_type" in
		"nor")
			restore_partition_nor $infile $partmtd || return 1 ;;
		"nand")
			restore_partition_nand $infile $partmtd || return 1 ;;
		*)
			msg " + Invalid flash type, are you on emulation mode?" ;;
	esac
}

function format_partition_vfat() {
# Description: Format partition <partmtd> as vfat
# Syntax: format_partition_vfat <partname> <partmtdblock>
	local partname="$1"
	local partmtdblock="$2"

	msg "- Format partition: $partname($partmtd) as vfat ---"
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "mkfs.vfat $partmtdblock"
	else
		msg_nonewline " + Formatting... "
		mkfs.vfat $partmtdblock && msg "succeeded" || { msg "failed" ; return 1 ; } 
	fi
}

function format_partition_jffs2() {
# Description: Format partition <partmtd> as jffs2
# Syntax: format_partition_jffs2 <partname> <partmtd>
	local partname="$1"
	local partmtd="$2"

	msg "- Format partition: $partname($partmtd) as jffs2 ---"	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "flash_eraseall -j $partmtd"
	else
		msg_nonewline " + Formatting... "
		flash_eraseall -j $partmtd && msg "succeeded" || { msg "failed" ; return 1 ; } 
	fi
}

function erase_partition() {
# Description: Erase partition <partmtd> using flash_eraseall
# Syntax: erase_partition <partname> <partmtd>
	local partname="$1"
	local partmtd="$2"

	msg "- Erase partition: $partname($partmtd) ---"
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "flash_eraseall $partmtd"
	else
		msg_nonewline " + Erasing... "
		flash_eraseall $partmtd && msg "succeeded" || { msg "failed" ; return 1 ; }
	fi
}

function leave_partition() {
# Description: Do absolutely nothing with the partition :))
# Syntax: leave_partition <partname> <partmtd>
	local partname="$1"
	local partmtd="$2"

	msg "- Leave partition: $partname($partmtd) ---"
		msg " + Leaving..."
}

function gen_4digit_id() {
# Description: Generate a number in 1000-9999 range
	shuf -i 1000-9999 -n 1
}
