[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | **Restore** | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | [FAQs](README_FAQs.md)

## Restore partitions guide

**Step 1:** [Setup](README_setup.md)
**Step 2:** Place your partition restore images at `(SD card)/wz_flash-helper/restore/(profile)`. They should have have this format: `(profile)_(SoC type)_(partition name).bin`, with `SoC type` is `t20`, `t31a` or `t31x`(eg. stock_t31x_kernel.bin).
**Step 3:** Edit `(SD card)/wz_flash-helper/restore/(profile).conf` to select what partitions will be restored:
**Step 4:** Edit `general.conf` to enable restore operation:
```
switch_profile="no"
restore_partitions="yes"
```
**Step 5:** Insert your SD card into your camera and reboot.


-----
**Note:**
- There is no option to restore your boot partition to avoid accidentally corrupting it.
- `switch_profile` option must be disabled like the above configurations. If both `restore_partitions` and `switch_profile`are enabled, both operations will not be executed.
- All partition restore images must come with their md5sum file in `(partition image).md5sum` format
- During restore operation, the red LED would be blinking every second.
- Typically restore operation takes about 2 minutes(for reference it takes 2 minutes 15 seconds on Wyze Cam v3)

