#!/bin/sh
#
# Description: Print out messages to both the serial terminal and the log files
#

function msg() {
# Description: Print messages to the serial terminal and the log files
	local message="$1"

	echo "$message" # Print to log file
	echo "$message" >> /tmp/initramfs_serial.log # Print to an extra log file. It is exactly the same as on the serial terminal
	echo "$message" > /dev/console # Print on the serial terminal
}

function msg_nonewline() {
# Description: Same as msg but without newline
	local message="$1"

	echo -n "$message"
	echo -n "$message" >> /tmp/initramfs_serial.log
	echo -n "$message" > /dev/console
}

function get_color_code() {
# Description: Return color code of a given color
	local color="$1"
	local message="$2"
	
	case $color in
		"black")
			echo -n "30" ;;
		"red")
			echo -n "31" ;;
		"green")
			echo -n "32" ;;
		"brown")
			echo -n "33" ;;
		"blue")
			echo -n "34" ;;
		"magenta")
			echo -n "35" ;;
		"cyan")
			echo -n "36" ;;
		"white")
			echo -n "37" ;;
		"lightgray")
			echo -n "90" ;;
		"lightred")
			echo -n "91" ;;
		"lightgreen")
			echo -n "92" ;;
		"lightbrown")
			echo -n "93" ;;
		"lightblue")
			echo -n "94" ;;
		"lightmagenta")
			echo -n "95" ;;
		"lightcyan")
			echo -n "96" ;;
		"lightwhite")
			echo -n "97" ;;
	esac
}

function msg_color() {
# Description: Print out messages to serial terminal with colored text
	local color="$1"
	local color_code=$(get_color_code $color)
	local message="$2"

	echo "$message"
	echo "$message" >> /tmp/initramfs_serial.log
        echo -e "\e[0;${color_code}m${message}\e[0m" > /dev/console
}

function msg_color_nonewline() {
# Description: Print out messages to serial terminal with colored text without newline
	local color="$1"
	local color_code=$(get_color_code $color)
	local message="$2"

	echo -n "$message"
	echo -n "$message" >> /tmp/initramfs_serial.log
        echo -ne "\e[0;${color_code}m${message}\e[0m" > /dev/console
}

function msg_color_bold() {
# Description: Print out messages to serial terminal with bold colored text
	local color="$1"
	local color_code=$(get_color_code $color)
	local message="$2"

	echo "$message"
	echo "$message" >> /tmp/initramfs_serial.log
        echo -e "\e[1;${color_code}m${message}\e[0m" > /dev/console
}

function msg_color_bold_nonewline() {
# Description: Print out messages to serial terminal with bold colored text without newline
	local color="$1"
	local color_code=$(get_color_code $color)
	local message="$2"

	echo -n "$message"
	echo -n "$message" >> /tmp/initramfs_serial.log
        echo -ne "\e[1;${color_code}m${message}\e[0m" > /dev/console
}

function msg_tickbox_yes() {
# Description: Display a tickbox with color
	local color_code_yes=$(get_color_code "lightgreen")
	
	echo -n "[x] "
	echo -n "[x] " >> /tmp/initramfs_serial.log 
	echo -ne "\e[1;${color_code_yes}m[x] \e[0m" > /dev/console
}

function msg_tickbox_no() {
# Description: Display a tickbox with color
	local color_code_no=$(get_color_code "lightbrown")
	
	echo -n "[ ] "
	echo -n "[ ] " >> /tmp/initramfs_serial.log
	echo -ne "\e[1;${color_code_no}m[ ] \e[0m" > /dev/console
}

function msg_dry_run() {
# Description: Print out commands instead of executing them when dry run is enabled
	local cmd="$1"

	echo "   (dry run) $cmd"
	echo "   (dry run) $cmd" >> /tmp/initramfs_serial.log
	echo "   (dry run) $cmd" > /dev/console
}
