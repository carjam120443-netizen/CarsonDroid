#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AOSP_DIR="${CARSON_AOSP_DIR:-${ROOT}/../aosp-carsondroid}"
DIST="${ROOT}/out/dist"
OUT="${ROOT}/out/ota"

if [[ ! -d "${AOSP_DIR}/.repo" ]]; then
  echo "AOSP checkout not found. Run ./scripts/setup-aosp.sh first."
  exit 1
fi

TARGET_FILES="$(find "${DIST}" -maxdepth 1 -type f -name '*target_files*.zip' | head -n1)"
if [[ -z "${TARGET_FILES}" ]]; then
  echo "No target-files ZIP found in ${DIST}. Build the CarsonDroid dist target first."
  exit 1
fi

mkdir -p "${OUT}"
OTA_TOOL="${AOSP_DIR}/build/tools/releasetools/ota_from_target_files"
if [[ ! -f "${OTA_TOOL}" ]]; then
  echo "AOSP OTA tooling is missing: ${OTA_TOOL}"
  exit 1
fi

python3 "${OTA_TOOL}" "${TARGET_FILES}" "${OUT}/CarsonDroid-ota.zip"
echo "OTA package: ${OUT}/CarsonDroid-ota.zip"
