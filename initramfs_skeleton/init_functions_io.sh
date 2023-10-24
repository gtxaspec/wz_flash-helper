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
		md5sum $outfile > $outfile.md5sum
		local outfile_dir=$(dirname $outfile) && sed -i "s|$outfile_dir/||g" $outfile.md5sum # Remove path of partition images files from their .md5sum files
	fi
}

function archive_stock_config_part_files() {
# Description: Backup all files from a JFFS2 partition to .tar.gz file
# Syntax: backup_stock_config_part_files_to_archive <partname> <partblockmtd> <outfile>
	local partname="$1"
	local partblockmtd="$2"
	local outfile="$3"
	local mountpoint_dir="$4"
	
	msg "- Backup: $partname files to file $outfile ---"
	
	mkdir -p $mountpoint_dir
	mount -t jffs2 $partblockmtd $mountpoint_dir || { msg "Mount $partname failed" ; exit_init ; }
	if [[ "$dry_run" == "yes" ]]; then
		msg_dry_run "tar -cvf $outfile -C $mountpoint_dir ."
		msg_dry_run "md5sum $outfile > $outfile.md5sum"
	else
		tar -cvf $outfile -C $mountpoint_dir .
		md5sum $outfile > $outfile.md5sum
	fi

	sync
	umount $mountpoint_dir && rmdir $mountpoint_dir
	msg " + backup succeeded"
}

function restore_file_to_partition() {
# Description: Restore partition from <infile> to <partmtd>
# Syntax: restore_file_to_partition <partname> <restore_stage_dir> <infile> <partname>
	local partname="$1"
	local restore_stage_dir="$2"
	local infile_name="$3"
	local partmtd="$4"
	
	cd "$restore_stage_dir"
	msg "- Restore: file $outfile to $partname at $partmtd ---"
	[ ! -f $infile_name ] && { msg " + $infile_name is missing" ; return 1 ; }
	
	msg_nonewline " + Checking md5 of $infile_name: "
	if [[ "$dry_run" == "yes" ]]; then
		md5sum -c $infile_name.md5sum && { msg "succeeded" ; msg_dry_run "flash_eraseall $partmtd && flashcp $infile_name $partmtd" ; } || { msg "failed" ; return 1 ; }
	else
		md5sum -c $infile_name.md5sum && { msg "succeeded" ; flash_eraseall $partmtd && flashcp $infile_name $partmtd && msg " + Restore succeeded" ; } || { msg "failed" ; return 1 ; }
	fi
}
