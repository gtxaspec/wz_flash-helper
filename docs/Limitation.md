[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md) | [Changelog](Changelog.md) | **Limitation**

- First initramfs shell is dropped after GPIO pins is initialized and kernel modules are loaded. This make testing new kernel modules and GPIO initialization difficult.

- Setting Wi-Fi password by the `setup_openipc_env.sh` script is still quite hassling if it contains single quotes `'`.

- There is no way to read/write/format UBI partitions on NAND flash yet. Bad block management is not supported.

- Currently, creating new profiles with flash configuration on `.json` or `.yaml` files has not been implemented.


