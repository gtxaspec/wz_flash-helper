#!/bin/bash
#
#  ___ ___     __                  _   _                 
# |_ _/ _ \   / _|_   _ _ __   ___| |_(_) ___  _ __  ___ 
#  | | | | | | |_| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#  | | |_| | |  _| |_| | | | | (__| |_| | (_) | | | \__ \
# |___\___/  |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#



function backup_partition_to_file() {
# Description: Backup partition <partmtd> to <outfile>
# Syntax: backup_partition_to_file <partname> <partmtd> <outfile>
	local partname="$1"
	local partmtd="$2"
	local outfile="$3"
	
	msg "- Backup: $partname at $partmtd to file $outfile ---"
	[ -f $outfile ] && { msg " + $outfile already exists" ; return 1 ; }
	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "dd if=$partmtd of=$outfile"
		msg_dry_run "md5sum $outfile > $outfile.md5sum"
		msg_dry_run "local outfile_dir=$(dirname $outfile) && sed -i \"s|\$outfile_dir/||g\" $outfile.md5sum"
	else
		dd if=$partmtd of=$outfile || { msg " + Failed to backup $partname" ; return 1 ; } && msg " + backup succeeded"
		md5sum $outfile > $outfile.md5sum || { msg " + Failed to generate md5sum for $outfile" ; return 1 ; }
		local outfile_dir=$(dirname $outfile) && sed -i "s|$outfile_dir/||g" $outfile.md5sum # Remove path of partition images files from their .md5sum files
	fi
}

function archive_partition_files() {
# Description: Backup all files from a JFFS2 partition to .tar.gz file
# Syntax: archive_partition_files <partname> <partblockmtd> <outfile>
	local partname="$1"
	local partblockmtd="$2"
	local outfile="$3"
	
	local archive_mnt_dir="/archive_mnt_$partname"
	mkdir -p $archive_mnt_dir
	
	msg "- Archive: $partname at $partblockmtd files to file $outfile ---"
	mount -t jffs2 $partblockmtd $archive_mnt_dir || { msg "Failed to mount mount $partname" ; return 1 ; }
	
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "tar -cvf $outfile -C $archive_mnt_dir ."
		msg_dry_run "md5sum $outfile > $outfile.md5sum"
	else
		tar -cvf $outfile -C $archive_mnt_dir . || { msg " + Failed to generate partiton archive for $partname" ; return 1 ; }
		md5sum $outfile > $outfile.md5sum || { msg " + Failed to generate md5sum for $outfile" ; return 1 ; }
	fi

	sync
	umount $mountpoint_dir && rmdir $mountpoint_dir
	msg " + backup succeeded"
}

function restore_file_to_partition() {
# Description: Restore partition from <infile> to <partmtd>, <infile> and its md5sum file will be copied to stage directory before proceed restoring
# Syntax: restore_file_to_partition <partname> <restore_stage_dir> <infile> <partname>
	local partname="$1"
	local infile="$2"
	local partmtd="$3"

	local infile_name=$(basename $infile)
	local restore_stage_dir="/restore_stage_dir"
	
	mkdir -p $restore_stage_dir
	cp $infile $restore_stage_dir/$infile_name || { msg " + $infile_name is missing" ; return 1 ; }
	cp $infile.md5sum $restore_stage_dir/$infile_name.md5sum || { msg " + $infile_name.md5sum is missing" ; return 1 ; }
	
	cd $restore_stage_dir
	msg "- Restore: file $infile_name to $partname at $partmtd ---"
	msg_nonewline " + Checking md5 of $infile_name: "
	if [[ "$dry_run" == "yes" ]]; then
		md5sum -c $infile_name.md5sum && { msg "succeeded" ; msg_dry_run "flash_eraseall $partmtd && flashcp $infile_name $partmtd" ; } || { msg "failed" ; return 1 ; }
	else
		md5sum -c $infile_name.md5sum && { msg "succeeded" ; msg_nonewline " + Writing... " ; flash_eraseall $partmtd && flashcp $infile_name $partmtd && msg "succeeded" ; } || { msg "failed" ; return 1 ; }
	fi
}

function erase_partition() {
# Description: Erase a partition using flash_eraseall
# Syntax: <partname> <partmtd>
	local partname="$1"
	local partmtd="$2"

	msg_nonewline "- Erase: $partname at $partmtd ---"
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "flash_eraseall $partmtd" && msg "succeeded"
	else
		flash_eraseall $partmtd && msg "succeeded" || { msg "failed" ; return 1 ; }
	fi
}

