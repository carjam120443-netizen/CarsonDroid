# CarsonDroid AOSP build machine

This directory provisions a dedicated Linux x86_64 host for building CarsonDroid and packaging the Android artifacts.

## Recommended host

AOSP currently documents a 64-bit x86 Linux workstation, at least 400 GB of free space, and 64 GB RAM for development builds. More CPU/RAM/SSD capacity makes full builds substantially faster.

Recommended CarsonDroid builder:

- Ubuntu 24.04 LTS x86_64
- 16+ CPU threads
- 64 GB RAM
- 1 TB SSD
- KVM enabled for Cuttlefish validation
- GitHub Actions self-hosted runner labels: `self-hosted`, `linux`, `x86_64`, `aosp`

## Provision

Run on the Linux host:

```bash
sudo ./build-machine/provision-ubuntu.sh
```

The script installs AOSP host dependencies, Repo, build utilities, KVM/Cuttlefish prerequisites, and creates the `carson` build workspace.

## GitHub Actions runner

Runner registration is deliberately not automated because GitHub runner registration requires an account/repository-specific authentication token. After installing a runner from GitHub's repository Actions settings, start it with the labels above.

The repository workflow `.github/workflows/build-iso.yml` targets those labels.

## Build locally

```bash
cd ~/CarsonDroid
./build-machine/build-on-host.sh
```

The host build script syncs Android's `android-latest-release`, overlays CarsonDroid, builds the x86_64 Cuttlefish target, and invokes the ISO/release packaging stages.
