#!/usr/bin/env bash

set -euo pipefail

DISTRO=""
DISTRO_VERSION=""
DISTRO_FAMILY=""
PACKAGE_MANAGER=""
INIT_SYSTEM=""

detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        DISTRO="$ID"
        DISTRO_VERSION="$VERSION_ID"
        
        # Determine distribution family
        case "$ID" in
            ubuntu|debian|linuxmint|pop|elementary|kali|parrot|deepin)
                DISTRO_FAMILY="debian"
                ;;
            fedora|rhel|centos|rocky|almalinux|oracle|scientific)
                DISTRO_FAMILY="fedora"
                ;;
            arch|manjaro|endeavouros|artix|garuda)
                DISTRO_FAMILY="arch"
                ;;
            opensuse*|suse*)
                DISTRO_FAMILY="suse"
                ;;
            gentoo|funtoo)
                DISTRO_FAMILY="gentoo"
                ;;
            alpine)
                DISTRO_FAMILY="alpine"
                ;;
            void)
                DISTRO_FAMILY="void"
                ;;
            nixos)
                DISTRO_FAMILY="nixos"
                ;;
            *)
                # Try to detect based on ID_LIKE
                if [[ -n "${ID_LIKE:-}" ]]; then
                    case "$ID_LIKE" in
                        *debian*) DISTRO_FAMILY="debian" ;;
                        *fedora*|*rhel*) DISTRO_FAMILY="fedora" ;;
                        *arch*) DISTRO_FAMILY="arch" ;;
                        *suse*) DISTRO_FAMILY="suse" ;;
                        *) DISTRO_FAMILY="unknown" ;;
                    esac
                else
                    DISTRO_FAMILY="unknown"
                fi
                ;;
        esac
    elif [[ -f /etc/redhat-release ]]; then
        DISTRO="rhel"
        DISTRO_FAMILY="fedora"
        DISTRO_VERSION=$(rpm -q --queryformat '%{VERSION}' redhat-release 2>/dev/null || echo "unknown")
    elif [[ -f /etc/debian_version ]]; then
        DISTRO="debian"
        DISTRO_FAMILY="debian"
        DISTRO_VERSION=$(cat /etc/debian_version)
    elif [[ -f /etc/arch-release ]]; then
        DISTRO="arch"
        DISTRO_FAMILY="arch"
        DISTRO_VERSION="rolling"
    elif [[ -f /etc/gentoo-release ]]; then
        DISTRO="gentoo"
        DISTRO_FAMILY="gentoo"
        DISTRO_VERSION="rolling"
    elif [[ -f /etc/alpine-release ]]; then
        DISTRO="alpine"
        DISTRO_FAMILY="alpine"
        DISTRO_VERSION=$(cat /etc/alpine-release)
    else
        DISTRO="unknown"
        DISTRO_FAMILY="unknown"
        DISTRO_VERSION="unknown"
    fi
    
    # Detect package manager
    detect_package_manager
    
    # Detect init system
    detect_init_system
}

detect_package_manager() {
    if command -v apt-get &> /dev/null; then
        PACKAGE_MANAGER="apt"
    elif command -v dnf &> /dev/null; then
        PACKAGE_MANAGER="dnf"
    elif command -v yum &> /dev/null; then
        PACKAGE_MANAGER="yum"
    elif command -v pacman &> /dev/null; then
        PACKAGE_MANAGER="pacman"
    elif command -v zypper &> /dev/null; then
        PACKAGE_MANAGER="zypper"
    elif command -v emerge &> /dev/null; then
        PACKAGE_MANAGER="portage"
    elif command -v apk &> /dev/null; then
        PACKAGE_MANAGER="apk"
    elif command -v xbps-install &> /dev/null; then
        PACKAGE_MANAGER="xbps"
    elif command -v nix-env &> /dev/null; then
        PACKAGE_MANAGER="nix"
    elif command -v brew &> /dev/null; then
        PACKAGE_MANAGER="brew"
    else
        PACKAGE_MANAGER="unknown"
    fi
}

detect_init_system() {
    if [[ -d /run/systemd/system ]]; then
        INIT_SYSTEM="systemd"
    elif command -v openrc &> /dev/null; then
        INIT_SYSTEM="openrc"
    elif [[ -f /sbin/init ]] && file /sbin/init | grep -q "SysV"; then
        INIT_SYSTEM="sysv"
    elif command -v rc-service &> /dev/null; then
        INIT_SYSTEM="openrc"
    elif [[ -d /etc/runit ]]; then
        INIT_SYSTEM="runit"
    else
        INIT_SYSTEM="unknown"
    fi
}

is_distro() {
    local check_distro="$1"
    [[ "$DISTRO" == "$check_distro" ]]
}

is_distro_family() {
    local check_family="$1"
    [[ "$DISTRO_FAMILY" == "$check_family" ]]
}

has_package_manager() {
    local check_pm="$1"
    [[ "$PACKAGE_MANAGER" == "$check_pm" ]]
}

get_distro_info() {
    cat << EOF
Distribution: $DISTRO
Version: $DISTRO_VERSION
Family: $DISTRO_FAMILY
Package Manager: $PACKAGE_MANAGER
Init System: $INIT_SYSTEM
EOF
}

# Export functions
export -f detect_distro detect_package_manager detect_init_system
export -f is_distro is_distro_family has_package_manager get_distro_info

# Export variables
export DISTRO DISTRO_VERSION DISTRO_FAMILY PACKAGE_MANAGER INIT_SYSTEM