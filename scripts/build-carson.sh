#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AOSP_DIR="${CARSON_AOSP_DIR:-${ROOT}/../aosp-carsondroid}"

if [[ ! -d "${AOSP_DIR}/.repo" ]]; then
  echo "AOSP checkout not found. Run ./scripts/setup-aosp.sh first."
  exit 1
fi

for tree in device vendor packages/apps; do
  mkdir -p "${AOSP_DIR}/${tree}"
  cp -a "${ROOT}/${tree}/." "${AOSP_DIR}/${tree}/"
done

cd "${AOSP_DIR}"
source build/envsetup.sh

LUNCH_TARGET="${CARSON_LUNCH_TARGET:-aosp_cf_x86_64_phone-aosp_current-userdebug}"
echo "Building target: ${LUNCH_TARGET}"
lunch "${LUNCH_TARGET}"

m "${CARSON_MAKE_ARGS:--j$(nproc)}" dist

mkdir -p "${ROOT}/out/dist"
cp -a out/dist/. "${ROOT}/out/dist/"

echo
echo "CarsonDroid/AOSP build finished. Artifacts are in: ${ROOT}/out/dist"
