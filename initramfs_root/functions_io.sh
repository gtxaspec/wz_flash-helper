#!/bin/bash
#
# Description: IO functions
#

function read_partition_nor() {
# Description: Dump partition <partmtd> to <outfile> on NOR flash
# Syntax: read_partition_nor <partmtd> <outfile>
	local partmtd="$1"
	local outfile="$2"
	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "dd if=$partmtd of=$outfile"
	else
		msg_nonewline "    Reading... "
		dd if=$partmtd of=$outfile && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
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
		msg_nonewline "    Reading... "
		nanddump -f $outfile $partmtd && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
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
	
	msg_color_bold_nonewline white "-> Read partition: "
	msg_color_nonewline brown "$partname "
	msg_color_nonewline magenta "$partmtd "
	msg_nonewline "to file "
	msg_color brown "$outfile_basename"
	
	[ ! -c $partmtd ] && { msg_color red "    $partmtd is not a character device" ; return 1 ; }
	[ -f $outfile ] && { msg_color red "    $outfile_basename already exists" ; return 1 ; }
	
	case "$flash_type" in
		"nor")
			read_partition_nor $partmtd $outfile || return 1
			;;
		"nand")
			read_partition_nand $partmtd $outfile || return 1
			;;
	esac
	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "sha256sum $outfile > $outfile.sha256sum"
		msg_dry_run "sed -i \"s|$outfile_dirname/||g\" $outfile.sha256sum"
	else
		msg_nonewline "    Generating sha256sum file... "
		sha256sum $outfile > $outfile.sha256sum && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
		sed -i "s|$outfile_dirname/||g" $outfile.sha256sum # Remove path of the partition image from its .sha256sum file
	fi
}

function write_partition_nor() {
# Description: Write to <partmtd> partition using <infile> on NOR flash
# Syntax: write_partition_nor <infile> <partmtd>
	local infile="$1"
	local partmtd="$2"

	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "flash_eraseall $partmtd"
		msg_dry_run "flashcp $infile $partmtd"
	else
		msg_nonewline "    Writing... "
		flash_eraseall $partmtd || { msg_color red "failed" ; return 1 ; }
		flashcp $infile $partmtd && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
	fi
}

function write_partition_nand() {
# Description: Write to <partmtd> partition using <infile> on NAND flash
# Syntax: write_partition_nand <infile> <partmtd>
	local infile="$1"
	local partmtd="$2"
	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "unpad_partimg $infile $blocksize $infile.unpadded"
		msg_dry_run "flash_eraseall $partmtd"
		msg_dry_run "nandwrite -p $partmtd $infile.unpadded"
	else
		msg_nonewline "    Creating unpadded partition image..."
		unpad_partimg $infile $blocksize $infile.unpadded && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
		
		msg_nonewline "    Writing... "
		flash_eraseall $partmtd || { msg_color red "failed" ; return 1 ; }
		nandwrite -p $partmtd $infile.unpadded && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
		rm $infile.unpadded
	fi
}

function write_partition() {
# Description: Write <infile> to <partmtd> partition, <infile> and its sha256sum file will be copied to the stage directory before proceed with writing
# Syntax: write_partition <partname> <infile> <partmtd>
	local partname="$1"
	local infile="$2"
	local infile_basename=$(basename $infile)
	local partmtd="$3"
	local restore_stage_dir="/restore_stage_dir"
	
	mkdir -p $restore_stage_dir
	
	msg_color_bold_nonewline white "-> Write partition: "
	msg_nonewline "file "
	msg_color_nonewline brown "$infile_basename "
	msg_nonewline "to "
	msg_color_nonewline brown "$partname "
	msg_color magenta "$partmtd"

	[ ! -c $partmtd ] && { msg_color red "    $partmtd is not a character device" ; return 1 ; }
	[ ! -f $infile ] && { msg_color red "    $infile_basename is missing" ; return 1 ; }
	[ ! -f $infile.sha256sum ] && { msg_color red "    $infile_basename.sha256sum is missing" ; return 1 ; }
	
	cp $infile $restore_stage_dir/$infile_basename
	cp $infile.sha256sum $restore_stage_dir/$infile_basename.sha256sum

	msg_nonewline "    Verifying file... "
	( cd $restore_stage_dir ; sha256sum -c $infile_basename.sha256sum ) && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }

	case "$flash_type" in
		"nor")
			write_partition_nor $restore_stage_dir/$infile_basename $partmtd || return 1
			;;
		"nand")
			write_partition_nand $restore_stage_dir/$infile_basename $partmtd || return 1
			;;
	esac
	
	rm $restore_stage_dir/$infile_basename
	rm $restore_stage_dir/$infile_basename.sha256sum
}

function create_archive_from_partition() {
# Description: Create .tar.gz archive from partition <partmtdblock> files
# Syntax: create_archive_from_partition <partname> <partmtdblock> <fstype> <outfile>
	local partname="$1"
	local partmtdblock="$2"
	local fstype="$3"
	local outfile="$4"
	local outfile_basename=$(basename $outfile)
	local outfile_dirname=$(dirname $outfile)
	local archive_mnt="/archive_mnt_$partname"
	
	mkdir -p $archive_mnt
	
	msg_color_bold_nonewline white "-> Archive partition files: "
	msg_color_nonewline brown "$partname "
	msg_color_nonewline magenta "$partmtdblock "
	msg_nonewline "to file "
	msg_color brown "$outfile_basename"

	[ ! -b $partmtdblock ] && { msg_color red "    $partmtdblock is not a block device" ; return 1 ; }
	[ -f $outfile ] && { msg_color red "    $outfile_basename already exists" ; return 1 ; }
		
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "mount -o ro -t $fstype $partmtdblock $archive_mnt"
		msg_dry_run "tar -czf $outfile -C $archive_mnt ."
		msg_dry_run "sha256sum $outfile > $outfile.sha256sum"
		msg_dry_run "sed -i \"s|$outfile_dirname/||g\" $outfile.sha256sum"
	else
		mount -o ro -t $fstype $partmtdblock $archive_mnt || { msg_color red "Failed to mount $partname" ; return 1 ; }
		msg_nonewline "    Creating archive file... "
		tar -czf $outfile -C $archive_mnt . && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
		msg_nonewline "    Generating sha256sum file... "
		sha256sum $outfile > $outfile.sha256sum && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
		sed -i "s|$outfile_dirname/||g" $outfile.sha256sum # Remove path from .sha256sum file
		
		umount $archive_mnt && rmdir $archive_mnt
	fi
	
	sync

}

function extract_archive_to_partition() {
# Description: Extract an archive to partition <partmtdblock>
# Syntax: extract_archive_to_partition <partname> <infile> <partmtdblock> <fstype>
	local partname="$1"
	local infile="$2"
	local infile_basename=$(basename $infile)
	local infile_dirname=$(dirname $infile)
	local partmtdblock="$3"
	local fstype="$4"
	local unarchive_mnt="/unarchive_mnt_$partname"
	
	mkdir -p $unarchive_mnt
	
	msg_color_bold_nonewline white "-> Extract archive to partition: "
	msg_nonewline "file "
	msg_color_nonewline brown "$infile_basename "
	msg_nonewline "to "
	msg_color_nonewline brown "$partname "
	msg_color magenta "$partmtdblock"

	[ ! -f $infile ] && { msg_color red "    $infile_basename is missing" ; return 1 ; }
	[ ! -b $partmtdblock ] && { msg_color red "    $partmtdblock is not a block device" ; return 1 ; }
	
	msg_nonewline "    Verifying file... "
	( cd $infile_dirname && sha256sum -c $infile_basename.sha256sum ) && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }

	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "mount -o rw -t $fstype $partmtdblock $unarchive_mnt"
		msg_dry_run "tar -xf $infile -C $unarchive_mnt"
	else
		mount -o rw -t $fstype $partmtdblock $unarchive_mnt || { msg_color red "Failed to mount $partname" ; return 1 ; }
		msg_nonewline "    Extracting archive file... "
		tar -xf $infile -C $unarchive_mnt && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
		
		umount $unarchive_mnt && rmdir $unarchive_mnt
	fi
	
	sync
}

function format_partition_vfat() {
# Description: Format partition <partmtd> as VFAT
# Syntax: format_partition_vfat <partmtdblock>
	local partmtdblock="$1"

	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "mkfs.vfat $partmtdblock"
	else
		msg_nonewline "    Formatting... "
		mkfs.vfat $partmtdblock && msg_color green "ok" || { msg_color red "failed" ; return 1 ; } 
	fi
}

function format_partition_jffs2() {
# Description: Format partition <partmtd> as JFFS2
# Syntax: format_partition_jffs2 <partmtd>
	local partmtd="$1"

	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "flash_eraseall -j $partmtd"
	else
		msg_nonewline "    Formatting... "
		flash_eraseall -j $partmtd && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
	fi
}

function format_partition() {
# Description: Format partition with <partnum> as <partfstype>
# Syntax: format_partition <partname> <partnum> <partfstype>
	local partname="$1"
	local partnum="$2"
	local partfstype="$3"
	local partmtd="/dev/mtd$partnum"
	local partmtdblock="/dev/mtdblock$partnum"

	case $partfstype in
		"jffs2")
			msg_color_bold_nonewline white "-> Format partition: "
			msg_color_nonewline brown "$partname "
			msg_color_nonewline magenta "$partmtd "
			msg_nonewline "as "
			msg_color lightbrown "$partfstype"
			;;
		"vfat")
			msg_color_bold_nonewline white "-> Format partition: "
			msg_color_nonewline brown "$partname "
			msg_color_nonewline magenta "$partmtdblock "
			msg_nonewline "as "
			msg_color lightbrown "$partfstype"
			;;
		*)
			msg_color red "    Formating partition as $partfstype is not supported"
			return 1
			;;
	esac

	[ ! -c $partmtd ] && { msg_color red "    $partmtd is not a character device" ; return 1 ; }
	[ ! -b $partmtdblock ] && { msg_color red "    $partmtdblock is not a block device" ; return 1 ; }

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

	msg_color_bold_nonewline white "-> Erase partition: "
	msg_color_nonewline brown "$partname"
	msg_color magenta " $partmtd"

	[ ! -c $partmtd ] && { msg_color red "    $partmtd is not a character device" ; return 1 ; }
	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "flash_eraseall $partmtd"
	else
		msg_nonewline "    Erasing... "
		flash_eraseall $partmtd && msg_color green "ok" || { msg_color red "failed" ; return 1 ; }
	fi
}

function leave_partition() {
# Description: Do absolutely nothing with the partition :))
# Syntax: leave_partition <partname> <partmtd>
	local partname="$1"
	local partmtd="$2"

	msg_color_bold_nonewline white "-> Leave partition: "
	msg_color_nonewline brown "$partname "
	msg_color magenta "$partmtd"
	msg "    Leaving..."
}

function validate_written_partition() {
# Description: Validate if the written partition is the same as the partition image that was used to write it. The validation can be done up to three times if it fails
# Syntax: validate_written_partition <partname> <partnum> <verifyfile>
	local partname="$1"
	local partnum="$2"
	local partmtd="/dev/mtd$partnum"
	local partmtdblock="/dev/mtdblock$partnum"
	local verifyfile="$3"
	local verifyfile_basename=$(basename $verifyfile)
	local partimg_verify="/verify_$partname.img"
	
	msg_color_bold_nonewline white "> Validating written partition: "
	msg_color_nonewline brown "$partname "
	msg_color_nonewline magenta "$partmtdblock "
	msg_nonewline "against file "
	msg_color brown "$verifyfile_basename"
	
	[ ! -b $partmtdblock ] && { msg_color red "    $partmtdblock is not a block device" ; return 1 ; }
	[ ! -f $verifyfile ] && { msg_color red "    $verifyfile_basename is missing" ; return 1 ; }
	
	for attempt in 1 2 3; do
		msg_color_bold white "-> Validation attempt $attempt:"
		
		local verifyfile_hash=$(sha256sum $verifyfile | cut -d ' ' -f1)
		
		msg_nonewline "    Hash of "
		msg_color_nonewline brown "$verifyfile_basename"
		msg_nonewline ": "
		msg_color cyan "$verifyfile_hash"
		
		local verifyfile_blocksize=$(du -b $verifyfile | cut -f -1)
		
		case "$flash_type" in
			"nor")
				dd if=$partmtdblock of=$partimg_verify bs=1 count=$verifyfile_blocksize
				;;
			"nand")
				nanddump -f $partimg_verify.nand $partmtd
				dd if=$partimg_verify.nand of=$partimg_verify bs=1 count=$verifyfile_blocksize
				rm $partimg_verify.nand
				;;
		esac
		
		local partimg_verify_hash=$(sha256sum $partimg_verify | cut -d ' ' -f1)
		rm $partimg_verify
		
		msg_nonewline "    Hash of "
		msg_color_nonewline brown "$partname"
		msg_nonewline ": "
		msg_color cyan "$partimg_verify_hash"
		
		msg_nonewline "    Validation result: "
		[[ "$verifyfile_hash" == "$partimg_verify_hash" ]] && { msg_color green "good" ; return 0 ; } || msg_color red "bad"
	done
	return 1
}
