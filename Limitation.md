
- First initramfs shell is dropped after GPIO pins is initialized and kernel modules are loaded. This make testing new kernel modules GPIO initialization difficult.

- Setting Wi-Fi password by the `setup_openipc_env.sh` script is still quite hassling if it contains single quotes `'`.

- There is no way to read/write/format UBI partitions on NAND flash yet. Bad block management is not supported.

- Currently, creating new profiles with flash configuration on `.json` or `.yaml` files has not been implemented.


