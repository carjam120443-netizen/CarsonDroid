#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE="${ROOT}/out/CarsonDroid-x86_64.img"

if [[ "${1:-}" == "" ]]; then
  echo "Usage: $0 /dev/sdX-or-nvme-device" >&2
  echo "This writes the prepared CarsonDroid disk image to the selected device." >&2
  exit 2
fi

DEVICE="$1"
if [[ ! -f "${IMAGE}" ]]; then
  echo "Disk image not found: ${IMAGE}" >&2
  exit 1
fi

if [[ ! -b "${DEVICE}" ]]; then
  echo "Not a block device: ${DEVICE}" >&2
  exit 1
fi

case "${DEVICE}" in
  /dev/sda|/dev/sdb|/dev/sdc|/dev/nvme*|/dev/vd*) ;;
  *) echo "Refusing unexpected device path: ${DEVICE}" >&2; exit 1 ;;
esac

echo "About to overwrite ${DEVICE} with ${IMAGE}."
read -r -p "Type INSTALL to continue: " CONFIRM
[[ "${CONFIRM}" == "INSTALL" ]] || { echo "Cancelled."; exit 1; }

command -v dd >/dev/null || { echo "Missing dd" >&2; exit 1; }
dd if="${IMAGE}" of="${DEVICE}" bs=16M status=progress conv=fsync
sync
echo "CarsonDroid image written to ${DEVICE}."
