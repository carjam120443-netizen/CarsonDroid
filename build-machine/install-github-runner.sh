#!/usr/bin/env bash
set -euo pipefail

# CarsonDroid GitHub Actions self-hosted runner bootstrap.
# Run this on the dedicated Linux AOSP build machine.
# The registration token must be generated in the repository's
# Settings -> Actions -> Runners -> New self-hosted runner page.

REPO="${CARSON_GITHUB_REPO:-carjam120443-netizen/CarsonDroid}"
RUNNER_DIR="${CARSON_RUNNER_DIR:-/opt/actions-runner}"
RUNNER_VERSION="${CARSON_RUNNER_VERSION:-2.329.0}"
RUNNER_ARCH="${CARSON_RUNNER_ARCH:-x64}"
RUNNER_LABELS="${CARSON_RUNNER_LABELS:-linux,x86_64,aosp}"
RUNNER_USER="${CARSON_RUNNER_USER:-$(id -un)}"

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "This runner bootstrap must be run on Linux." >&2
  exit 1
fi

if [[ "$(uname -m)" != "x86_64" && "$(uname -m)" != "amd64" ]]; then
  echo "CarsonDroid's runner is intended for x86_64 Linux." >&2
  exit 1
fi

if [[ "${RUNNER_USER}" == "root" ]]; then
  echo "Run this script as the normal runner user, not root." >&2
  exit 1
fi

command -v curl >/dev/null || { echo "Missing curl." >&2; exit 1; }
command -v tar >/dev/null || { echo "Missing tar." >&2; exit 1; }

if [[ -z "${GITHUB_RUNNER_TOKEN:-}" ]]; then
  cat >&2 <<'EOF'
No GITHUB_RUNNER_TOKEN was supplied.

Create a temporary repository runner token in:
  GitHub -> CarsonDroid -> Settings -> Actions -> Runners -> New self-hosted runner

Then run this script with:
  GITHUB_RUNNER_TOKEN='TOKEN' ./build-machine/install-github-runner.sh

The token is used only for registration and should not be committed to the repo.
EOF
  exit 1
fi

mkdir -p "${RUNNER_DIR}"
cd "${RUNNER_DIR}"

ARCHIVE="actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz"
URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${ARCHIVE}"

if [[ ! -f .runner ]]; then
  if [[ ! -f "${ARCHIVE}" ]]; then
    echo "Downloading GitHub Actions runner ${RUNNER_VERSION}..."
    curl -fL --retry 3 -o "${ARCHIVE}" "${URL}"
  fi

  tar xzf "${ARCHIVE}"

  ./config.sh \
    --url "https://github.com/${REPO}" \
    --token "${GITHUB_RUNNER_TOKEN}" \
    --name "carsondroid-aosp-$(hostname -s)" \
    --labels "${RUNNER_LABELS}" \
    --work _work \
    --replace
fi

if command -v sudo >/dev/null 2>&1; then
  sudo ./svc.sh install "${RUNNER_USER}" || true
  sudo ./svc.sh start || true
else
  echo "sudo is unavailable; start the runner manually with: ./run.sh"
fi

echo
echo "CarsonDroid self-hosted runner configured."
echo "Repository: https://github.com/${REPO}"
echo "Labels: self-hosted, ${RUNNER_LABELS}"
echo "Runner directory: ${RUNNER_DIR}"
