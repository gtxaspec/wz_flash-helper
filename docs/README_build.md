[Introduction](README.md) | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch profile](README_switch_profile.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | **Build** | [FAQs](README_FAQs.md) | [Changelog](Changelog.md) | [Limitation](Limitation.md)


## 📄 Overview

wz_flash-helper uses OpenIPC kernel source. The compilation steps are the same as building OpenIPC kernels after the kernel config files are patched.

## ‍🍳 Prerequisites

A Linux distro with `git`, `fakeroot`, `cpio` and other [Buildroot mandatory packages](https://buildroot.org/downloads/manual/manual.html#requirement-mandatory) installed. 2GB free disk space is also required.

Building with WSL2 is NOT supported.

## 🔨 Build

**1. Prepare**

Clone the Github repo:
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

To generate a release, run:
```
./build.sh release <SoC>
```

where as `SoC` is either `t20` or `t31`

To clean up, run:
```
./build.sh clean
```
To build everything, run:
```
./build.sh clean && ./build.sh release t20 && ./build.sh release t31
```

Compiled kernels and releases will be saved at `output/` directory.

## ℹ️ Notes

- Cloning the Github repo takes between 30 seconds and 15 minutes, depending on your Internet speed.
- On the first time you build a kernel/release, it takes between 2 minutes and 20 minutes to download necessary toolchains before the compiling, after that it takes only about a minute.
