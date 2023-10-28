#!/bin/sh




import_current_profile() {
	source /profile.d/$current_profile/current_profile_queries.sh
	source /profile.d/$current_profile/current_profile_variables.sh
}

import_next_profile() {
	[[ "$switch_profile" == "yes" ]] || exit 0
	
	if [[ "$switch_profile_with_all_partitions" == "yes" ]]; then
		source /profile.d/$next_profile/next_profile_switch_profile_allparts.sh
	else
		source /profile.d/$next_profile/next_profile_switch_profile_basicparts.sh
	fi
}

init_import() {
	concat_bootpart="/dev/mtd0"
	concat_partmtd="/dev/mtd1"
	
	import_current_profile
	import_next_profile
}

init_import
