#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AOSP_DIR="${CARSON_AOSP_DIR:-${ROOT}/../aosp-carsondroid}"
AOSP_BRANCH="${CARSON_AOSP_BRANCH:-android-latest-release}"

mkdir -p "${AOSP_DIR}"
cd "${AOSP_DIR}"

if [[ ! -d .repo ]]; then
  repo init -u https://android.googlesource.com/platform/manifest -b "${AOSP_BRANCH}"
else
  echo "AOSP repo already initialized in ${AOSP_DIR}"
fi

repo sync -c -j"${CARSON_SYNC_JOBS:-$(nproc)}" --no-clone-bundle --no-tags

echo
printf 'AOSP source ready at: %s\n' "${AOSP_DIR}"
printf 'Branch/manifest: %s\n' "${AOSP_BRANCH}"
printf 'Next: ./scripts/build-carson.sh\n'
