#############################################
# Chapel + Arkouda environment auto-config
# Safe to source from ~/.bashrc
#############################################

# Only activate for interactive shells
[[ $- != *i* ]] && return

# Avoid re-running
[[ -n "${CHAPEL_ENV_LOADED}" ]] && return
export CHAPEL_ENV_LOADED=1

#############################################
# Detect Linux distribution
#############################################

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO_ID="${ID,,}"
#   DISTRO_LIKE="${ID_LIKE,,}"
else
    DISTRO_ID="unknown"
#   DISTRO_LIKE=""
fi

#############################################
# Helper: find highest available llvm-config
#############################################

find_llvm_config() {
    for v in 18 17 16 15 14; do
        if command -v llvm-config-$v >/dev/null 2>&1; then
            echo "$(command -v llvm-config-$v)"
            return
        fi
    done
    command -v llvm-config 2>/dev/null
}

#############################################
# Base defaults (shared)
#############################################

unset CC CXX CFLAGS CXXFLAGS CPPFLAGS LDFLAGS

export CHPL_TARGET_COMPILER=clang
export CHPL_RT_COMPILER=clang
export CHPL_TASKS=qthreads
export CHPL_COMM=none

# Prefer system LLVM
export CHPL_LLVM=system
export CHPL_LLVM_CONFIG="$(find_llvm_config)"

# Defensive: only set if found
if [[ -z "$CHPL_LLVM_CONFIG" ]]; then
    echo "⚠️  Warning: llvm-config not found; Chapel build may fail"
fi

#############################################
# Distro-specific overrides
#############################################

case "$DISTRO_ID" in

    ubuntu|linuxmint)
        # Ubuntu / Mint are LLVM-friendly
        export CHPL_TARGET_LD=lld
        export CHPL_TARGET_MEM=jemalloc
        export GASNET_CFLAGS="-fPIC"
        ;;

    fedora)
        # Fedora defaults are stricter
        export CHPL_TARGET_LD=lld
        export CHPL_TARGET_MEM=jemalloc
        export GASNET_CFLAGS="-fPIC"
        export GASNET_LDFLAGS="-latomic"
        ;;

    almalinux|rhel|rocky)
        # RHEL-family quirks
        export CHPL_TARGET_LD=lld
        export CHPL_TARGET_MEM=jemalloc
        export GASNET_CFLAGS="-fPIC"
        export GASNET_LDFLAGS="-latomic"
        export CHPL_ATOMICS=cstdlib
        ;;

    *)
        echo "⚠️  Unknown distro: $DISTRO_ID"
        ;;
esac

#############################################
# Arkouda-specific sanity helpers
#############################################

# Ensure python build uses correct compiler
export ARKOUDA_COMPILER=clang

# Prevent accidental mixed-toolchain builds
export CHPL_SANITIZE=none

#############################################
# Optional: quick diagnostics function
#############################################

chapel_env() {
    echo "Distro:          $DISTRO_ID"
    echo "llvm-config:     $CHPL_LLVM_CONFIG"
    echo "Compiler:        $CHPL_TARGET_COMPILER"
    echo "Runtime:         $CHPL_RT_COMPILER"
    echo "Tasks:           $CHPL_TASKS"
    echo "Comm:            $CHPL_COMM"
    echo "Memory:          ${CHPL_MEM:-default}"
}

#############################################
# End
#############################################
