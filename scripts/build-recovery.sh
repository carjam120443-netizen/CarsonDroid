#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AOSP_DIR="${AOSP_DIR:-${ROOT}/aosp}"
OUT="${AOSP_DIR}/out/target/product/vsoc_x86_64"

if [[ ! -d "${AOSP_DIR}" ]]; then
  echo "AOSP checkout not found at ${AOSP_DIR}." >&2
  exit 1
fi

if [[ ! -f "${OUT}/recovery.img" ]]; then
  echo "AOSP did not produce recovery.img yet." >&2
  echo "This script is intentionally a validation hook until CarsonDroid has a real recovery target." >&2
  exit 1
fi

mkdir -p "${ROOT}/out"
cp "${OUT}/recovery.img" "${ROOT}/out/CarsonDroid-recovery.img"
echo "Created ${ROOT}/out/CarsonDroid-recovery.img"
