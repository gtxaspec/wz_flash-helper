[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch firmware](README_switch_firmware.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md) | [Changelog](Changelog.md) | **Limitation**

- There is no way to read/write/format UBI partitions on NAND flash yet, same with bad block management.

- Currently, creating new profiles with flash configuration on `.json` or `.yaml` files has not been implemented.

- The term "Switch firmware" causes a lot of confusion to the users, it has been here since `v0.6.0`.

- Partition image verification limitation:
   - For restore: each partition image is verified. If one succeeds, it is written. If the second partition image verification fails, the first partition image is already written, this might cause a soft-brocked camera.
   - For switch firmware: The verification progress stops immediately if one partition image verificaion fails. It doesn't tell if the remaining unverified partition images fail or not.

- Wi-Fi vendor ID file at `/sys/bus/mmc/devices/mmc1:0001/mmc1:0001:1/vendor` might randomly(?) change to `/sys/bus/mmc/devices/mmc1:0002/mmc1:0002:1/vendor` or `/sys/bus/mmc/devices/mmc1:0003/mmc1:0003:1/vendor` for undetermined reasons, a temporary fix for this is using wildcard(already implemented).

- Current code for LEDs blinking currently only work with cameras with 2 LEDs, to support more cameras that have one or no LED some minor changes are needed.
