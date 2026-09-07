#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This helper currently targets Debian/Ubuntu hosts."
  exit 1
fi

sudo apt-get update
sudo apt-get install -y \
  git-core gnupg flex bison build-essential zip curl zlib1g-dev \
  libc6-dev-i386 libx11-dev lib32z1-dev libgl1-mesa-dev \
  libxml2-utils xsltproc unzip fontconfig python3

if ! command -v repo >/dev/null 2>&1; then
  sudo apt-get install -y repo || true
fi

if ! command -v repo >/dev/null 2>&1; then
  mkdir -p "${HOME}/bin"
  curl -L https://storage.googleapis.com/git-repo-downloads/repo \
    -o "${HOME}/bin/repo"
  chmod a+rx "${HOME}/bin/repo"
  echo "Add ${HOME}/bin to PATH if repo is not found in new shells."
fi

echo "AOSP host dependencies installed."
