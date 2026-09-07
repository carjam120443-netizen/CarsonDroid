#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AOSP_DIR="${CARSON_AOSP_DIR:-/opt/aosp/aosp-carsondroid}"
export CARSON_AOSP_DIR="${AOSP_DIR}"

if [[ ! -x /usr/local/bin/repo ]]; then
  echo "Repo is not installed. Run sudo ./build-machine/provision-ubuntu.sh first." >&2
  exit 1
fi

mkdir -p "${AOSP_DIR}"
if [[ ! -d "${AOSP_DIR}/.repo" ]]; then
  cd "${AOSP_DIR}"
  repo init --partial-clone --no-use-superproject -u https://android.googlesource.com/platform/manifest -b "${CARSON_AOSP_BRANCH:-android-latest-release}"
fi

cd "${AOSP_DIR}"
repo sync -c -j"${CARSON_SYNC_JOBS:-8}" --no-clone-bundle --no-tags

cd "${ROOT}"
./scripts/build-carson.sh

# The ISO packager is intentionally run only after the Android build succeeds.
./scripts/build-iso.sh
./scripts/build-release-bundle.sh

echo
echo "CarsonDroid build complete."
find "${ROOT}/out" -maxdepth 1 -type f -printf '%f\n' | sort
