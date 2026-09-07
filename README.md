# CarsonDroid

AOSP-based custom Android OS focused first on x86_64 virtualization, reproducible builds, and a clean custom system layer.

## Target

- Android 17 (`android17-release` / `android-latest-release`)
- x86_64
- Cuttlefish first
- VirtualBox/QEMU packaging after the baseline works
- userdebug development builds

The full AOSP checkout is intentionally **not vendored** into this repository. `scripts/setup-aosp.sh` initializes and syncs the official AOSP source tree locally with Repo.

## Quick start

```bash
./scripts/setup-aosp.sh
./scripts/build-carson.sh
```

## Layout

```text
build/          Build helpers
configs/        Project configuration
device/         CarsonDroid device/product definitions
packages/apps/  CarsonDroid applications
scripts/        Bootstrap and build scripts
vendor/carson/  Product properties and overlays
.github/        CI workflows
```

## Roadmap

1. Bootstrap and sync AOSP.
2. Build an unmodified x86_64 Cuttlefish baseline.
3. Introduce the CarsonDroid product configuration.
4. Add CarsonDroid Settings, Launcher, Files, and Reboot Center.
5. Add branding, overlays, defaults, and SystemUI customization.
6. Produce reproducible artifacts.
7. Add VirtualBox/QEMU-oriented image packaging.
8. Add release and update infrastructure.

## License

CarsonDroid project files are Apache-2.0 unless otherwise noted. AOSP and third-party components retain their upstream licenses.
