
[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | **Build** | [FAQs](README_FAQs.md_)

## Build guide

Prerequisites:
A Linux OS with:
- fakeroot
- cpio

WSL2 has not been tested

1. Download source code from Github repo:
```
git submodule update --init --recursive https://github.com/archandanime/wz_flash-helper.git
```

2. Patch OpenIPC kernel source:
```
./build.sh patch
```

3. Build kernels:
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

