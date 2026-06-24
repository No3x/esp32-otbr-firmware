# ESP32 OpenThread RCP firmware with USB UART retry patch

Builds reproducible-ish ESP32-C5, ESP32-C6, and ESP32-H2 OpenThread RCP firmware for Home Assistant OTBR.

This is **not ESPHome firmware**. The ESP32 becomes an OpenThread RCP radio used by the Home Assistant OpenThread Border Router add-on.

## What it builds

GitHub Actions builds the ESP-IDF `examples/openthread/ot_rcp` example as a matrix, applies the USB UART retry patch, and uploads a merged image for each target:

- `generic-esp32c5.bin`
- `generic-esp32c6.bin`
- `generic-esp32h2.bin`
- `xiao-esp32c6-external-antenna.bin`

Each artifact also includes the component images used to make the merged binary:

- `bootloader.bin`
- `partition-table.bin`
- `esp_ot_rcp.bin`
- `idf-commit.txt`

## Releases

Pushing a version tag that starts with `v`, such as `v1.0.0`, builds all firmware variants and publishes a GitHub Release. The release includes the merged firmware images, component images for each board, ESP-IDF commit records, and `SHA256SUMS.txt` checksums. Re-running the workflow for an existing tag updates the release assets in place.

## Flash

Download the firmware image for your board from the latest GitHub Release or workflow artifact, then flash the merged `.bin` with a browser-based tool such as [ESPHome Web](https://web.esphome.io/), or unzip the artifact and use `esptool`:

```bash
pip install esptool
esptool.py --chip auto write-flash 0x0 generic-esp32c6.bin
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
