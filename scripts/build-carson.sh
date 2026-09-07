#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AOSP_DIR="${CARSON_AOSP_DIR:-${ROOT}/../aosp-carsondroid}"

if [[ ! -d "${AOSP_DIR}/.repo" ]]; then
  echo "AOSP checkout not found. Run ./scripts/setup-aosp.sh first."
  exit 1
fi

# Overlay the CarsonDroid-owned trees into the AOSP checkout.
for tree in device vendor packages/apps; do
  mkdir -p "${AOSP_DIR}/${tree}"
  cp -a "${ROOT}/${tree}/." "${AOSP_DIR}/${tree}/"
done

cd "${AOSP_DIR}"
source build/envsetup.sh
lunch carsondroid_x86_64-userdebug

# The first milestone is a complete, bootable x86_64 Cuttlefish build.
m "${CARSON_MAKE_ARGS:--j$(nproc)}" dist

mkdir -p "${ROOT}/out/dist"
cp -a out/dist/. "${ROOT}/out/dist/"

echo
echo "CarsonDroid build finished. Artifacts are in: ${ROOT}/out/dist"
