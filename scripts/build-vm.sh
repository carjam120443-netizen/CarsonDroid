#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST="${ROOT}/out/dist"
VM_OUT="${ROOT}/out/vm"

mkdir -p "${VM_OUT}"

if [[ ! -d "${DIST}" ]]; then
  echo "No AOSP dist output found. Run ./scripts/build-carson.sh first."
  exit 1
fi

# Keep this packaging step conservative: AOSP/Cuttlefish artifacts are copied
# verbatim so we do not corrupt sparse images or OTA packages.
find "${DIST}" -maxdepth 1 -type f \
  \( -name '*img*' -o -name '*.zip' -o -name '*.zip.md5' \) \
  -exec cp -v {} "${VM_OUT}/" \;

cat > "${VM_OUT}/README.txt" <<'EOF'
CarsonDroid VM artifacts

The first supported VM target is AOSP Cuttlefish x86_64.
VirtualBox/QEMU disk conversion will be added after the native CarsonDroid
Cuttlefish image boots reliably.
EOF

echo "VM artifacts staged in ${VM_OUT}"
