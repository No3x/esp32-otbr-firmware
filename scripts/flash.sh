#!/usr/bin/env bash
set -euo pipefail

PORT="${1:-/dev/ttyACM0}"
BAUD="${BAUD:-460800}"

if ! command -v esptool.py >/dev/null 2>&1; then
  echo "esptool.py not found. Install with: pip install esptool" >&2
  exit 1
fi

esptool.py --chip esp32c6 -p $PORT -b $BAUD \
  --before default_reset --after hard_reset write_flash \
  0x0 result.bin
