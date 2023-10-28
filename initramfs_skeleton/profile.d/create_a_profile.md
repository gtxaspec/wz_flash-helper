
## How to create a firmware profile

**Step 1:** Under `firmware_profile.d` create a directory with your profile name.

**Step 2:** Create these files using template profile:
```
current_profile_queries.sh
current_profile_variables.sh
next_profile_queries.sh
next_profile_switch_profile_allparts.sh
next_profile_switch_profile_basicparts.sh
next_profile_variables.sh
```

**Step 3:** Modify `prepare_detect.sh` script to specify how your profile can be detected.

**Step 4:** Modify `prepare_import.sh` script to specify SD card boot image name.

**Step 5:** Modify `wz_flash-helper.conf` file to add options for what partitions can be restored with restore operation.

When switching from another profile to your new profile, you can create `boot_hashes.d` directory and add files in <another profile>.txt to put md5 hashes of your new profile, boot partition image from restore directory must match its hash in order to be written. Otherwise, the switch firmware operation would fail.
