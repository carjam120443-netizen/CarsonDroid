#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${ROOT}/configs/carsondroid.conf"
source "${ROOT}/configs/partitions.conf"

OUT="${ROOT}/out"
IMAGE="${OUT}/CarsonDroid-x86_64.img"
SIZE_MB=$((EFI_SIZE_MB + BOOT_SIZE_MB + SYSTEM_SIZE_MB + SYSTEM_EXT_SIZE_MB + PRODUCT_SIZE_MB + VENDOR_SIZE_MB + CACHE_SIZE_MB + USERDATA_SIZE_MB + 256))

mkdir -p "${OUT}"
command -v truncate >/dev/null || { echo 'Missing truncate' >&2; exit 1; }
command -v sgdisk >/dev/null || { echo 'Missing sgdisk (install gdisk)' >&2; exit 1; }

truncate -s "${SIZE_MB}M" "${IMAGE}"
sgdisk --zap-all "${IMAGE}"
sgdisk --new=1:2048:+${EFI_SIZE_MB}M --typecode=1:ef00 --change-name=1:EFI "${IMAGE}"
sgdisk --new=2:0:+${BOOT_SIZE_MB}M --typecode=2:8300 --change-name=2:boot "${IMAGE}"
sgdisk --new=3:0:+${SYSTEM_SIZE_MB}M --typecode=3:8300 --change-name=3:system "${IMAGE}"
sgdisk --new=4:0:+${SYSTEM_EXT_SIZE_MB}M --typecode=4:8300 --change-name=4:system_ext "${IMAGE}"
sgdisk --new=5:0:+${PRODUCT_SIZE_MB}M --typecode=5:8300 --change-name=5:product "${IMAGE}"
sgdisk --new=6:0:+${VENDOR_SIZE_MB}M --typecode=6:8300 --change-name=6:vendor "${IMAGE}"
sgdisk --new=7:0:+${CACHE_SIZE_MB}M --typecode=7:8300 --change-name=7:cache "${IMAGE}"
sgdisk --new=8:0:0 --typecode=8:8300 --change-name=8:userdata "${IMAGE}"
sgdisk --print "${IMAGE}"
echo "Created partitioned CarsonDroid disk image: ${IMAGE}"
echo "Note: filesystem population and Android dynamic-partition metadata are completed by the AOSP build/install stage."
