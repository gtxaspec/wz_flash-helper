[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | **Build** | [FAQs](README_FAQs.md)



## Prerequisites

A Linux OS with `fakeroot` and `cpio` packages
WSL2 has not been tested.

## Build

Download source code from Github repo:
```
git submodule update --init --recursive https://github.com/archandanime/wz_flash-helper.git
```

Patch OpenIPC kernel source:
```
./build.sh patch
```

Build kernel:
```
./build.sh kernel <SoC>
```
example:
```
./build.sh kernel t20
```

You can also generate a release by running:
```
./build.sh release <SoC>
```
example:
```
./build.sh release t20
```

