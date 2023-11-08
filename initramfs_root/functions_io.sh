#!/bin/bash
#
#  ___ ___     __                  _   _                 
# |_ _/ _ \   / _|_   _ _ __   ___| |_(_) ___  _ __  ___ 
#  | | | | | | |_| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#  | | |_| | |  _| |_| | | | | (__| |_| | (_) | | | \__ \
# |___\___/  |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#



function read_partition_nor() {
# Description: Dump partition <partmtd> to <outfile> on NOR flash
# Syntax: read_partition_nor <partmtd> <outfile>
	local partmtd="$1"
	local outfile="$2"
	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "dd if=$partmtd of=$outfile"
	else
		msg_nonewline " + Reading... "
		dd if=$partmtd of=$outfile && msg "ok" || { msg "failed" ; return 1 ; } 
	fi
}

function read_partition_nand() {
# Description: Dump partition <partmtd> to <outfile> on NAND flash
# Syntax: read_partition_nand <partmtd> <outfile>
	local partmtd="$1"
	local outfile="$2"
	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "nanddump -f $outfile $partmtd"
	else
		msg_nonewline " + Reading... "
		nanddump -f $outfile $partmtd && msg "ok" || { msg "failed" ; return 1 ; } 
	fi
}

function read_partition() {
# Description: Dump partition <partmtd> to <outfile>
# Syntax: read_partition <partname> <partmtd> <outfile>
	local partname="$1"
	local partmtd="$2"
	local outfile="$3"
	local outfile_basename=$(basename $outfile)
	local outfile_dirname=$(dirname $outfile)
	
	msg "- Read from flash: $partname($partmtd) to file $outfile_basename ---"
	
	[ ! -c $partmtd ] && { msg " + $partmtd is not a character device" ; return 1 ; }
	[ -f $outfile ] && { msg " + $outfile_basename already exists" ; return 1 ; }
	
	case "$flash_type" in
		"nor")
			read_partition_nor $partmtd $outfile || return 1
			;;
		"nand")
			read_partition_nand $partmtd $outfile || return 1
			;;
		*)
			msg " + Invalid flash type: $flash_type"
			return 1
			;;
	esac
	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "sha256sum $outfile > $outfile.sha256sum"
		msg_dry_run "sed -i \"s|$outfile_dirname/||g\" $outfile.sha256sum"
	else
		msg_nonewline " + Generating sha256sum file... "
		sha256sum $outfile > $outfile.sha256sum && msg "ok" || { msg "failed" ; return 1 ; } 
		sed -i "s|$outfile_dirname/||g" $outfile.sha256sum # Remove path from .sha256sum file
	fi
}

function write_partition_nor() {
# Description: Write to <partmtd> partition using <infile> on NOR flash
# Syntax: write_partition_nor <infile> <partmtd>
	local infile="$1"
	local partmtd="$2"

	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "flashcp $infile $partmtd"
	else
		msg_nonewline " + Writing... "
		flashcp $infile $partmtd && msg "ok" || { msg "failed" ; return 1 ; } 
	fi
}

function write_partition_nand() {
# Description: Write to <partmtd> partition using <infile> on NAND flash
# Syntax: write_partition_nand <infile> <partmtd>
	local infile="$1"
	local partmtd="$2"
	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "nandwrite -p $partmtd $infile"
	else
		msg_nonewline " + Writing... "
		nandwrite -p $partmtd $infile && msg "ok" || { msg "failed" ; return 1 ; } 
	fi
}

function write_partition() {
# Description: Write <infile> to <partmtd> partition, <infile> and its sha256sum file will be copied to stage directory before proceed writing
# Syntax: write_partition <partname> <infile> <partmtd>
	local partname="$1"
	local infile="$2"
	local infile_basename=$(basename $infile)
	local partmtd="$3"

	local restore_stage_dir="/restore_stage_dir"
	mkdir -p $restore_stage_dir
	
	msg "- Write to flash: file $infile_basename to $partname($partmtd) ---"

	[ ! -c $partmtd ] && { msg " + $partmtd is not a character device" ; return 1 ; }
	[ ! -f $infile ] && { msg " + $infile_basename is missing" ; return 1 ; }
	[ ! -f $infile.sha256sum ] && { msg " + $infile_basename.sha256sum is missing" ; return 1 ; }
	
	cp $infile $restore_stage_dir/$infile_basename
	cp $infile.sha256sum $restore_stage_dir/$infile_basename.sha256sum

	msg_nonewline " + Verifying file... "
	( cd $restore_stage_dir ; sha256sum -c $infile_basename.sha256sum ) && msg "ok" || { msg "failed" ; return 1 ; }

	case "$flash_type" in
		"nor")
			write_partition_nor $infile $partmtd || return 1
			;;
		"nand")
			write_partition_nand $infile $partmtd || return 1
			;;
		*)
			msg " + Invalid flash type: $flash_type"
			return 1
			;;
	esac
}

function create_archive_from_partition() {
# Description: Create .tar.gz archive from partition <partmtdblock> files
# Syntax: create_archive_from_partition <partname> <partblockmtd> <fstype> <outfile>
	local partname="$1"
	local partblockmtd="$2"
	local fstype="$3"
	local outfile="$4"
	local outfile_basename=$(basename $outfile)
	local outfile_dirname=$(dirname $outfile)
	
	local archive_mnt="/archive_mnt_$partname"
	mkdir -p $archive_mnt
	
	msg "- Archive partition files: $partname($partblockmtd) to file $outfile_basename ---"

	[ ! -b $partmtdblock ] && { msg " + $partmtdblock is not a block device" ; return 1 ; }
	[ -f $outfile ] && { msg " + $outfile_basename already exists" ; return 1 ; }
		
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "mount -o ro -t $fstype $partblockmtd $archive_mnt"
		msg_dry_run "tar -czf $outfile -C $archive_mnt ."
		msg_dry_run "sha256sum $outfile > $outfile.sha256sum"
		msg_dry_run "sed -i \"s|$outfile_dirname/||g\" $outfile.sha256sum"
	else
		mount -o ro -t $fstype $partblockmtd $archive_mnt || { msg "Failed to mount $partname" ; return 1 ; }
		msg_nonewline " + Creating archive file... "
		tar -czf $outfile -C $archive_mnt . && msg "ok" || { msg "failed" ; return 1 ; }
		msg_nonewline " + Generating sha256sum file... "
		sha256sum $outfile > $outfile.sha256sum && msg "ok" || { msg "failed" ; return 1 ; }
		sed -i "s|$outfile_dirname/||g" $outfile.sha256sum # Remove path from .sha256sum file
		
		umount $archive_mnt && rmdir $archive_mnt
	fi
	
	sync

}

function extract_archive_to_partition() {
# Description: Extract an archive to partition <partmtdblock>
# Syntax: extract_archive_to_partition <partname> <infile> <partblockmtd> <fstype>
	local partname="$1"
	local infile="$2"
	local infile_basename=$(basename $infile)
	local infile_dirname=$(dirname $infile)
	local partblockmtd="$3"
	local fstype="$4"
	
	local unarchive_mnt="/unarchive_mnt_$partname"
	mkdir -p $unarchive_mnt
	
	msg "- Extract archive to partition: file $infile_basename to $partname($partblockmtd) ---"

	[ ! -f $infile ] && { msg " + $infile_basename is missing" ; return 1 ; }
	[ ! -b $partmtdblock ] && { msg " + $partmtdblock is not a block device" ; return 1 ; }
	
	msg_nonewline " + Verifying file... "
	( cd $infile_dirname && sha256sum -c $infile_basename.sha256sum ) && msg "ok" || { msg "failed" ; return 1 ; }

	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "mount -o rw -t $fstype $partblockmtd $unarchive_mnt"
		msg_dry_run "tar -xf $infile -C $unarchive_mnt"
	else
		mount -o rw -t $fstype $partblockmtd $unarchive_mnt || { msg "Failed to mount $partname" ; return 1 ; }
		msg_nonewline " + Extracting archive file... "
		tar -xf $infile -C $unarchive_mnt && msg "ok" || { msg "failed" ; return 1 ; }
		
		umount $unarchive_mnt && rmdir $unarchive_mnt
	fi
	
	sync
}

function format_partition_vfat() {
# Description: Format partition <partmtd> as vfat
# Syntax: format_partition_vfat <partmtdblock>
	local partmtdblock="$1"

	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "mkfs.vfat $partmtdblock"
	else
		msg_nonewline " + Formatting... "
		mkfs.vfat $partmtdblock && msg "ok" || { msg "failed" ; return 1 ; } 
	fi
}

function format_partition_jffs2() {
# Description: Format partition <partmtd> as jffs2
# Syntax: format_partition_jffs2 <partmtd>
	local partmtd="$1"

	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "flash_eraseall -j $partmtd"
	else
		msg_nonewline " + Formatting... "
		flash_eraseall -j $partmtd && msg "ok" || { msg "failed" ; return 1 ; } 
	fi
}

function format_partition() {
# Description: Format partition <partnum>
	local partname="$1"
	local partnum="$2"
	local partfstype="$3"
	local partmtd="/dev/mtd$partnum"
	local partmtdblock="/dev/mtdblock$partnum"
	

	case $partfstype in
		"jffs2")
			msg "- Format partition: $partname($partmtd) as $partfstype ---"
			;;
		"vfat")
			msg "- Format partition: $partname($partmtdblock) as $partfstype ---"
			;;
		*)
			msg " + Formating partition as $partfstype is not supported"
			return 1
			;;
	esac

	[ ! -c $partmtd ] && { msg " + $partmtd is not a character device" ; return 1 ; }
	[ ! -b $partmtdblock ] && { msg " + $partmtdblock is not a block device" ; return 1 ; }

	case $partfstype in
		"jffs2")
			format_partition_jffs2 $partmtd || return 1
			;;
		"vfat")
			format_partition_vfat $partmtdblock || return 1
			;;
	esac
}

function erase_partition() {
# Description: Erase partition <partmtd> using flash_eraseall
# Syntax: erase_partition <partname> <partmtd>
	local partname="$1"
	local partmtd="$2"

	msg "- Erase partition: $partname($partmtd) ---"

	[ ! -c $partmtd ] && { msg " + $partmtd is not a character device" ; return 1 ; }
	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "flash_eraseall $partmtd"
	else
		msg_nonewline " + Erasing... "
		flash_eraseall $partmtd && msg "ok" || { msg "failed" ; return 1 ; }
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

function validate_written_partition() {
# Description: Validate if written partition is the same as the partition image that was used to write. If the validation fails, it is done again up to three times
# Syntax: validate_written_partition <partname> <partmtdblock> <verifyfile>
	local partname="$1"
	local partmtdblock="$2"
	local verifyfile="$3"
	local verifyfile_basename=$(basename $verifyfile)
	local partimg_verify="/verify_$partname.img"

	msg "- Validating written $partname($partmtdblock) with $verifyfile_basename"
	
	[ ! -b $partmtdblock ] && { msg " + $partmtdblock is not a block device" ; return 1 ; }
	[ ! -f $verifyfile ] && { msg " + $verifyfile_basename is missing" ; return 1 ; }
	
	for attempt in 1 2 3; do
		msg " + Validation attempt $attempt:"
		
		local verifyfile_blocksize=$(du -b $verifyfile | cut -f -1)
		local verifyfile_hash=$(sha256sum $verifyfile | cut -d ' ' -f1)

		dd if=$partmtdblock of=$partimg_verify bs=1 count=$verifyfile_blocksize status=none
		local partimg_verify_hash=$(sha256sum $partimg_verify | cut -d ' ' -f1)		

		rm $partimg_verify
		
		msg " + Hash of partition image: $verifyfile_hash"
		msg " + Hash of written partition: $partimg_verify_hash"

		msg_nonewline " + Validation result: "
		[[ "$verifyfile_hash" == "$partimg_verify_hash" ]] && { msg "good" ; return 0 ; } || msg "bad"
	done
	return 1
}
