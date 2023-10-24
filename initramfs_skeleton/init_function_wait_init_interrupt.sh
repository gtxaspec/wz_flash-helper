#!/bin/sh



function wait_init_interrupt() {
# Description: Allow user to access initramfs shell
	msg
	msg
	echo "Press any key to interrupt init" > /dev/console
	
	exec 0< /dev/console
	read -r -s -n 1 -t 3
	if [[ "$?" -eq 0 ]]; then
		echo "Dropping a shell"
		exec 1> /dev/console
		exec 2> /dev/console
		exec /bin/sh
	fi
	echo "Action has timed out" > /dev/console
	msg
	msg
}
