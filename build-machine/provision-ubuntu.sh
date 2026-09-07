#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run with sudo: sudo ./build-machine/provision-ubuntu.sh" >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y \
  adb autoconf automake bc bison build-essential ccache clang cmake curl \
  flex g++-multilib gcc-multilib git git-lfs gnupg gperf imagemagick lib32ncurses-dev \
  lib32readline-dev lib32z1-dev libelf-dev liblz4-tool libncurses-dev libssl-dev \
  lzop lz4 m4 make ninja-build openjdk-21-jdk p7zip-full patch pkg-config \
  python3 python3-pip python3-venv rsync schedtool squashfs-tools unzip uuid-dev \
  xsltproc zip zlib1g-dev xorriso grub-pc-bin grub-efi-amd64-bin gdisk qemu-kvm \
  libvirt-daemon-system libvirt-clients bridge-utils cpu-checker

# Install the Repo launcher from Google's maintained public distribution.
install -d -m 0755 /usr/local/bin
curl -fsSL https://storage.googleapis.com/git-repo-downloads/repo -o /usr/local/bin/repo
chmod 0755 /usr/local/bin/repo

# Make AOSP's large source/build workload friendlier to repeated builds.
install -d -m 0775 -o "${SUDO_USER:-root}" -g "${SUDO_USER:-root}" /opt/aosp /opt/ccache

if [[ -n "${SUDO_USER:-}" && "${SUDO_USER}" != "root" ]]; then
  usermod -aG kvm,libvirt "${SUDO_USER}" || true
  chown -R "${SUDO_USER}:${SUDO_USER}" /opt/aosp /opt/ccache
fi

cat >/etc/profile.d/carsondroid-aosp.sh <<'EOF'
export USE_CCACHE=1
export CCACHE_DIR=/opt/ccache
export CARSON_AOSP_DIR=/opt/aosp/aosp-carsondroid
export CARSON_SYNC_JOBS=${CARSON_SYNC_JOBS:-8}
EOF

if command -v ccache >/dev/null 2>&1; then
  ccache --set-config=max_size=100G || true
fi

echo
echo "CarsonDroid AOSP build host provisioned."
echo "Log out/in before using the new KVM/libvirt group membership."
echo "AOSP workspace: /opt/aosp/aosp-carsondroid"
