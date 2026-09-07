#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${ROOT}/configs/carsondroid.conf"

OUT="${ROOT}/out"
RELEASE="${OUT}/CarsonDroid-${CARSONDROID_VERSION}-${CARSONDROID_ARCH}"
mkdir -p "${RELEASE}"

for f in CarsonDroid-x86_64.iso CarsonDroid-x86_64.img CarsonDroid-recovery.img; do
  [[ -f "${OUT}/${f}" ]] && cp "${OUT}/${f}" "${RELEASE}/"
done

cp "${ROOT}/LICENSE" "${RELEASE}/LICENSE"
cp "${ROOT}/README.md" "${RELEASE}/README.md"
printf '%s\n' "${CARSONDROID_VERSION}" > "${RELEASE}/VERSION"

if command -v sha256sum >/dev/null 2>&1; then
  (cd "${RELEASE}" && sha256sum * > SHA256SUMS)
fi

tar -C "${OUT}" -czf "${OUT}/CarsonDroid-${CARSONDROID_VERSION}-${CARSONDROID_ARCH}.tar.gz" "$(basename "${RELEASE}")"
echo "Release bundle created in ${RELEASE}"
