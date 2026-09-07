#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST="${ROOT}/out/dist"
RELEASE="${ROOT}/out/release"
VERSION="${CARSON_VERSION:-0.1.0-dev}"

if [[ ! -d "${DIST}" ]]; then
  echo "No build output found. Run ./scripts/build-carson.sh first."
  exit 1
fi

rm -rf "${RELEASE}"
mkdir -p "${RELEASE}/CarsonDroid-${VERSION}"
cp -a "${DIST}/." "${RELEASE}/CarsonDroid-${VERSION}/"

cat > "${RELEASE}/CarsonDroid-${VERSION}/BUILD-INFO.txt" <<EOF
CarsonDroid ${VERSION}
Android release: android17-release
Architecture: x86_64
Build type: userdebug

This release was produced from AOSP and CarsonDroid overlays.
EOF

( cd "${RELEASE}" && tar -czf "CarsonDroid-${VERSION}.tar.gz" "CarsonDroid-${VERSION}" )

echo "Release bundle: ${RELEASE}/CarsonDroid-${VERSION}.tar.gz"
