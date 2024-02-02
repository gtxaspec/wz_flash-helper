**Introduction** | [Setup](README_setup.md) | [Backup](README_backup.md) | [Restore](README_restore.md) | [Switch firmware](README_switch_firmware.md) | [Other options](README_other_options.md) | [Screenshots](README_screenshots.md) | [Build](README_build.md) | [FAQs](README_FAQs.md) | [Changelog](Changelog.md) | [Limitation](Limitation.md)

## Features

- Backup partitions
- Restore partitions
- Switch between stock and OpenIPC firmware
- No need to disassemble your camera
- Dry run option debugging
- Initramfs shell for manual debugging if you have serial connection
- Seamlessly boot with `wz_mini_hacks` on the next boot
- Customize partitions with custom scripts support
- Windows-friendly setup progress

## Supported cameras
<table>
    <thead>
        <tr>
            <th>SoC</th>
            <th>Camera model</th>
            <th>Support status</th>
            <th>Model code</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=2>Ingenic T20</td>
            <td>Wyze Cam v2</td>
            <td>✅ Supported</td>
            <td >v2</td>
        </tr>
        <tr>
            <td>Wyze Cam Pan</td>
            <td>⚠️ Untested</td>
            <td>pan_v1</td>
        </tr>
        <tr>
            <td rowspan=4>Ingenic T31</td>
            <td>Wyze Cam v3</td>
            <td>✅ Supported</td>
            <td>v3</td>
        </tr>
        <tr>
            <td>Wyze Cam Floodlight</td>
            <td>⚠️ Untested</td>
            <td>v3</td>
        </tr>
        <tr>
            <td>Wyze Cam Pan v2</td>
            <td>⚠️ Untested</td>
            <td>pan_v2</td>
        </tr>
        <tr>
            <td>ATOM Cam 2</td>
            <td>⚠️ Untested</td>
            <td>v3c</td>
        </tr>
    </tbody>
</table>

## Disclaimer

```
I am not responsible for bricking someone's cameras.
DO NOT DISCONNECT POWER when the Switch firmware operation is going on, this would brick your camera (unless you know how to recover with Ingenic Cloner or remove the flash chip and use SPI programmer).
It is also possible to brick your camera if you corrupt the U-boot partition with your custom scripts or inject dangerous commands into the configuration files.
```

## Credits

- Gtxaspec with his ideas, tips, hard work on OpenIPC drivers, U-boot SD card kernel booting, and testing.
- Mnakada with their Docker image to build the SD card kernel from [their repo](https://github.com/mnakada/atomcam_tools)
- [OpenIPC](https://github.com/OpenIPC) project and people with their tools, firmware, and tips.
