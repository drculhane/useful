#!/usr/bin/env bash
set -euo pipefail

#############################################
# Chapel bootstrap installer
# Distro-aware dependency installation
#############################################

CHAPEL_VERSION="${1:-2.6.0}"
CHAPEL_TARBALL="chapel-${CHAPEL_VERSION}.tar.gz"
CHAPEL_URL="https://github.com/chapel-lang/chapel/releases/download/${CHAPEL_VERSION}/${CHAPEL_TARBALL}"

#############################################
# Detect Linux distribution
#############################################

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO_ID="${ID,,}"
#   DISTRO_LIKE="${ID_LIKE,,}"
else
    echo "Cannot detect Linux distribution"
    exit 1
fi

echo "Detected distro: $DISTRO_ID"

#############################################
# Helper
#############################################

need_cmd() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "Missing required command: $1"
        exit 1
    }
}

#############################################
# Install dependencies
#############################################

install_deps_ubuntu() {
    sudo apt update
    sudo apt install -y \
        build-essential \
        clang \
        lld \
        llvm \
        llvm-dev \
        python3 \
        python3-venv \
        python3-dev \
        perl \
        m4 \
        cmake \
        pkg-config \
        libnuma-dev \
        libhwloc-dev \
        libjemalloc-dev \
        curl \
        wget
}

install_deps_fedora() {
    sudo dnf install -y \
        gcc \
        gcc-c++ \
        clang \
        lld \
        llvm \
        llvm-devel \
        python3 \
        python3-devel \
        perl \
        m4 \
        cmake \
        pkgconf-pkg-config \
        numactl-devel \
        hwloc-devel \
        jemalloc-devel \
        libatomic \
        curl \
        wget
}

install_deps_rhel() {
    sudo dnf install -y \
        gcc \
        gcc-c++ \
        clang \
        lld \
        llvm \
        llvm-devel \
        python3 \
        python3-devel \
        perl \
        m4 \
        cmake \
        pkgconf-pkg-config \
        numactl-devel \
        hwloc-devel \
        jemalloc-devel \
        libatomic \
        curl \
        wget
}

case "$DISTRO_ID" in
    ubuntu|linuxmint)
        install_deps_ubuntu
        ;;
    fedora)
        install_deps_fedora
        ;;
    almalinux|rocky|rhel)
        install_deps_rhel
        ;;
    *)
        echo "Unsupported distro: $DISTRO_ID"
        exit 1
        ;;
esac

#############################################
# Sanity checks
#############################################

for cmd in clang llvm-config python3 make; do
    need_cmd "$cmd"
done

#############################################
# Download Chapel
#############################################

if [[ ! -f "$CHAPEL_TARBALL" ]]; then
    echo "Downloading Chapel ${CHAPEL_VERSION}..."
    wget "$CHAPEL_URL"
else
    echo "Tarball already exists: $CHAPEL_TARBALL"
fi

#############################################
# Extract
#############################################

if [[ ! -d "chapel-${CHAPEL_VERSION}" ]]; then
    echo "Extracting Chapel..."
    tar -xzf "$CHAPEL_TARBALL"
else
    echo "Directory already exists: chapel-${CHAPEL_VERSION}"
fi

#############################################
# Final instructions
#############################################

cat <<EOF

=========================================================
Chapel ${CHAPEL_VERSION} is ready.

Next steps (recommended):

  cd chapel-${CHAPEL_VERSION}
  source ~/.chapel_env.sh     # your saved environmentVariables
  make cleanall
  make -j\$(nproc)

Notes:
- This script does NOT run make automatically.
- This avoids stale configuration when switching compilers.
- LLVM + Clang are installed system-wide.
=========================================================

EOF
