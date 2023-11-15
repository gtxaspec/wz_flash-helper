[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | **Build** | [FAQs](README_FAQs.md)


### 📖 Overview

wz_flash-helper uses OpenIPC kernel source. The compilation steps are the same as building OpenIPC kernels after patching kernel config files.

### ‍🍳 Prerequisites

A Linux distro with `git`, `fakeroot` and `cpio` packages installed.

Building with WSL2 has not been tested.

### 🔨 Build

**1. Prepare**

Download source code from the Github repo:
```
git clone --recurse-submodules https://github.com/archandanime/wz_flash-helper.git
cd wz_flash-helper
```

Patch OpenIPC kernel config:
```
./build.sh patch
```

**2. Build**

To build a kernel, run:
```
./build.sh kernel <SoC>
```
for example:
```
./build.sh kernel t20
```

To generate a release, run:
```
./build.sh release <SoC>
```
for example:
```
./build.sh release t20
```

To clean up, run:
```
./build.sh clean
```

### ℹ️ Notes

- On the first time you build a kernel/release, it takes about 3 minutes, after that it takes only about a minute.
