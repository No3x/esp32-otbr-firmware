# ESP32-C6 OpenThread RCP firmware with USB UART retry patch

Builds reproducible-ish ESP32-C6 OpenThread RCP firmware for Home Assistant OTBR.

This is **not ESPHome firmware**. The ESP32-C6 becomes an OpenThread RCP radio used by the Home Assistant OpenThread Border Router add-on.

## What it builds

GitHub Actions builds the ESP-IDF `examples/openthread/ot_rcp` example for `esp32c6`, applies the USB UART retry patch, and uploads:

- `bootloader.bin`
- `partition-table.bin`
- `ot_rcp.bin`
- `flasher_args.json`
- `flash.sh`
- `build-info.txt`

## Flash

Download the workflow artifact, unzip it, then:

```bash
pip install esptool
chmod +x flash.sh
./flash.sh /dev/ttyACM0
```

Or manually:

```bash
esptool.py --chip esp32c6 -p /dev/ttyACM0 -b 460800 \
  --before default_reset --after hard_reset write_flash \
  0x0 bootloader.bin \
  0x8000 partition-table.bin \
  0x10000 ot_rcp.bin
```

After flashing, configure Home Assistant OTBR with the serial device, preferably:

```text
/dev/serial/by-id/...
```

Disable hardware flow control.

## Version pinning

The workflow pins:

- ESP-IDF ref in `.github/workflows/build.yml`
- Ubuntu runner image
- Python version

For stricter reproducibility, replace the ESP-IDF tag with a specific commit SHA.

## Patch

Patch source: Home Assistant Community post #74, where the issue is described as USB UART sends intermittently failing and the proposed workaround is retrying until success.

The patch is stored at:

```text
patches/0001-openthread-usb-uart-retry-send.patch
```
