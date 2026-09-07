#!/usr/bin/env bash
set -euo pipefail

fail=0
check_cmd() {
  if command -v "$1" >/dev/null 2>&1; then echo "[OK] $1"; else echo "[MISSING] $1"; fail=1; fi
}

for cmd in git repo python3 javac adb ccache ninja xorriso grub-mkrescue sgdisk qemu-system-x86_64; do
  check_cmd "$cmd"
done

if [[ -e /dev/kvm ]]; then
  echo "[OK] /dev/kvm"
else
  echo "[WARN] /dev/kvm not available; Cuttlefish/KVM validation will not work."
fi

if grep -Eq 'vmx|svm' /proc/cpuinfo; then
  echo "[OK] CPU virtualization flag"
else
  echo "[WARN] CPU virtualization flag not detected."
fi

avail_gb="$(df -Pk /opt/aosp 2>/dev/null | awk 'NR==2 {printf "%d", $4/1024/1024}')"
echo "[INFO] Free space on /opt/aosp filesystem: ${avail_gb:-unknown} GiB"
if [[ "${avail_gb:-0}" =~ ^[0-9]+$ && "${avail_gb}" -lt 400 ]]; then
  echo "[WARN] AOSP documents at least 400 GB free for checkout + build."
fi

ram_gb="$(awk '/MemTotal/ {printf "%d", $2/1024/1024}' /proc/meminfo)"
echo "[INFO] RAM: ${ram_gb} GiB"
if [[ "${ram_gb}" -lt 64 ]]; then
  echo "[WARN] AOSP currently documents 64 GB RAM as the minimum development recommendation."
fi

exit "${fail}"
