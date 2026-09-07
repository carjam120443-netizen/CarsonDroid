# CarsonDroid

AOSP-based custom Android OS focused first on x86_64 virtualization, reproducible builds, and a clean custom system layer.

## Target

- Android 17 (`android17-release` / `android-latest-release`)
- x86_64
- Cuttlefish first
- Experimental VirtualBox/QEMU PC boot path
- GRUB BIOS/UEFI packaging
- Persistent disk-image layout
- userdebug development builds
- AOSP-compatible OTA packaging
- Recovery integration point

The full AOSP checkout is intentionally **not vendored** into this repository. `scripts/setup-aosp.sh` initializes and syncs the official AOSP source tree locally with Repo. AOSP currently directs developers to `android-latest-release`, which points to `android17-release`. citeturn0search3

## Quick start

```bash
./scripts/install-host-deps.sh
./scripts/setup-aosp.sh
./scripts/build-carson.sh
```

## Build artifacts

```bash
./scripts/build-vm.sh
./scripts/build-disk-image.sh
./scripts/build-iso.sh
./scripts/build-recovery.sh
./scripts/build-release-bundle.sh
```

The expected development artifacts are:

```text
out/CarsonDroid-x86_64.iso
out/CarsonDroid-x86_64.img
out/CarsonDroid-recovery.img
out/CarsonDroid-<version>-x86_64.tar.gz
```

The ISO and disk-image builders are packaging layers around the AOSP output. They do not pretend that a Cuttlefish boot image is automatically a PC-bootable Android installation.

## Installation

After a properly populated disk image has been built, the explicit installer can write it to a selected disk:

```bash
./scripts/install-to-disk.sh /dev/<target-device>
```

The script requires an explicit `INSTALL` confirmation and is intended for a dedicated target disk.

## OTA updates

CarsonDroid uses AOSP's target-files/release tooling rather than inventing a proprietary OTA container:

```bash
./scripts/make-ota.sh
```

## CI

`.github/workflows/build-iso.yml` defines the full AOSP → disk image → ISO → release bundle pipeline. It targets a Linux x86_64 self-hosted runner with the `aosp` label because a full AOSP build is substantially larger than a normal GitHub-hosted CI job.

## Architecture

See `docs/ARCHITECTURE.md` for the boot layers, persistent layout, VM targets, recovery plan, OTA architecture, and security modes.

## Layout

```text
boot/           Bootloader/ISO configuration
build/          Build helpers
configs/        Project and partition configuration
device/         CarsonDroid device/product definitions
docs/           Architecture and development documentation
packages/apps/  CarsonDroid applications
scripts/        Bootstrap, build, image, install, OTA and release tooling
vendor/carson/  Product properties and overlays
.github/        CI workflows
```

## Roadmap

1. Bootstrap and sync AOSP.
2. Build an unmodified x86_64 Cuttlefish baseline.
3. Introduce the CarsonDroid product configuration.
4. Add CarsonDroid Settings, Launcher, Files, and Reboot Center.
5. Add branding, overlays, defaults, and SystemUI customization.
6. Validate ADB, graphics, networking, input, storage, and shutdown/reboot.
7. Produce reproducible VM and PC-oriented artifacts.
8. Complete a real PC boot chain instead of treating Cuttlefish images as PC images.
9. Add persistent installation and recovery.
10. Add signed OTA/release infrastructure.
11. Produce versioned ISO, IMG, recovery, OTA, and release bundles.

## Important status note

The repository now contains the planned project infrastructure, but **a final bootable CarsonDroid ISO still requires an AOSP build on a sufficiently large Linux host**. The repository cannot manufacture a real Android userspace without those generated AOSP artifacts. The current AOSP bootloader work also distinguishes the Cuttlefish path from the PC boot path. AOSP documents a UEFI Generic Bootloader (GBL) that can boot Android on x86_64 Cuttlefish, which is a useful future direction for the PC boot implementation. citeturn0search4

## License

CarsonDroid project files are covered by the custom license in `LICENSE`. AOSP and third-party components retain their upstream licenses. The custom license does not replace or relicense upstream Android components.
