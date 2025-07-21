#!/usr/bin/env bash

set -euo pipefail

# Define log function if not already defined
if ! declare -f log &>/dev/null; then
    log() {
        local level=$1
        shift
        local message="$*"
        
        case $level in
            ERROR) echo -e "\033[0;31m[ERROR]\033[0m $message" >&2 ;;
            WARN)  echo -e "\033[0;33m[WARN]\033[0m $message" ;;
            INFO)  echo -e "\033[0;34m[INFO]\033[0m $message" ;;
            SUCCESS) echo -e "\033[0;32m[SUCCESS]\033[0m $message" ;;
        esac
    }
fi

update_package_cache() {
    case "$PACKAGE_MANAGER" in
        apt)
            sudo apt-get update
            ;;
        dnf)
            sudo dnf check-update || true
            ;;
        yum)
            sudo yum check-update || true
            ;;
        pacman)
            sudo pacman -Sy
            ;;
        zypper)
            sudo zypper refresh
            ;;
        portage)
            sudo emerge --sync
            ;;
        apk)
            sudo apk update
            ;;
        xbps)
            sudo xbps-install -S
            ;;
        nix)
            nix-channel --update
            ;;
        brew)
            brew update
            ;;
        *)
            log WARN "Unknown package manager: $PACKAGE_MANAGER"
            return 1
            ;;
    esac
}

install_packages() {
    local packages=("$@")
    
    if [[ ${#packages[@]} -eq 0 ]]; then
        return 0
    fi
    
    # Map common package names to distro-specific names
    local mapped_packages=()
    for pkg in "${packages[@]}"; do
        local mapped_pkg=$(map_package_name "$pkg")
        if [[ -n "$mapped_pkg" ]]; then
            mapped_packages+=("$mapped_pkg")
        fi
    done
    
    case "$PACKAGE_MANAGER" in
        apt)
            sudo apt-get install -y "${mapped_packages[@]}"
            ;;
        dnf)
            sudo dnf install -y "${mapped_packages[@]}"
            ;;
        yum)
            sudo yum install -y "${mapped_packages[@]}"
            ;;
        pacman)
            sudo pacman -S --noconfirm "${mapped_packages[@]}"
            ;;
        zypper)
            sudo zypper install -y "${mapped_packages[@]}"
            ;;
        portage)
            sudo emerge "${mapped_packages[@]}"
            ;;
        apk)
            sudo apk add "${mapped_packages[@]}"
            ;;
        xbps)
            sudo xbps-install -y "${mapped_packages[@]}"
            ;;
        nix)
            nix-env -i "${mapped_packages[@]}"
            ;;
        brew)
            brew install "${mapped_packages[@]}"
            ;;
        *)
            log ERROR "Unknown package manager: $PACKAGE_MANAGER"
            return 1
            ;;
    esac
}

remove_packages() {
    local packages=("$@")
    
    if [[ ${#packages[@]} -eq 0 ]]; then
        return 0
    fi
    
    case "$PACKAGE_MANAGER" in
        apt)
            sudo apt-get remove -y "${packages[@]}"
            ;;
        dnf)
            sudo dnf remove -y "${packages[@]}"
            ;;
        yum)
            sudo yum remove -y "${packages[@]}"
            ;;
        pacman)
            sudo pacman -R --noconfirm "${packages[@]}"
            ;;
        zypper)
            sudo zypper remove -y "${packages[@]}"
            ;;
        portage)
            sudo emerge --unmerge "${packages[@]}"
            ;;
        apk)
            sudo apk del "${packages[@]}"
            ;;
        xbps)
            sudo xbps-remove -y "${packages[@]}"
            ;;
        nix)
            nix-env -e "${packages[@]}"
            ;;
        brew)
            brew uninstall "${packages[@]}"
            ;;
        *)
            log ERROR "Unknown package manager: $PACKAGE_MANAGER"
            return 1
            ;;
    esac
}

is_package_installed() {
    local package="$1"
    
    case "$PACKAGE_MANAGER" in
        apt)
            dpkg -l "$package" 2>/dev/null | grep -q "^ii"
            ;;
        dnf|yum)
            rpm -q "$package" &>/dev/null
            ;;
        pacman)
            pacman -Q "$package" &>/dev/null
            ;;
        zypper)
            rpm -q "$package" &>/dev/null
            ;;
        portage)
            equery list "$package" &>/dev/null
            ;;
        apk)
            apk info -e "$package" &>/dev/null
            ;;
        xbps)
            xbps-query "$package" &>/dev/null
            ;;
        nix)
            nix-env -q "$package" &>/dev/null
            ;;
        brew)
            brew list "$package" &>/dev/null
            ;;
        *)
            return 1
            ;;
    esac
}

map_package_name() {
    local package="$1"
    
    # Define package name mappings
    case "$package" in
        "build-essential")
            case "$DISTRO_FAMILY" in
                debian) echo "build-essential" ;;
                fedora) echo "make gcc gcc-c++ kernel-devel" ;;
                arch) echo "base-devel" ;;
                suse) echo "devel_basis" ;;
                alpine) echo "build-base" ;;
                macos) echo "" ;;  # Xcode Command Line Tools handle this
                *) echo "gcc make" ;;
            esac
            ;;
        "python3")
            case "$DISTRO_FAMILY" in
                debian|fedora|suse) echo "python3" ;;
                arch) echo "python" ;;
                alpine) echo "python3" ;;
                macos) echo "python3" ;;
                *) echo "python3" ;;
            esac
            ;;
        "python3-pip")
            case "$DISTRO_FAMILY" in
                debian) echo "python3-pip" ;;
                fedora) echo "python3-pip" ;;
                arch) echo "python-pip" ;;
                suse) echo "python3-pip" ;;
                alpine) echo "py3-pip" ;;
                *) echo "python3-pip" ;;
            esac
            ;;
        "nodejs")
            case "$DISTRO_FAMILY" in
                debian|fedora|suse) echo "nodejs" ;;
                arch) echo "nodejs" ;;
                alpine) echo "nodejs" ;;
                *) echo "nodejs" ;;
            esac
            ;;
        "npm")
            case "$DISTRO_FAMILY" in
                debian|fedora|suse) echo "npm" ;;
                arch) echo "npm" ;;
                alpine) echo "npm" ;;
                *) echo "npm" ;;
            esac
            ;;
        "vim")
            case "$DISTRO_FAMILY" in
                debian|fedora|arch|suse) echo "vim" ;;
                alpine) echo "vim" ;;
                *) echo "vim" ;;
            esac
            ;;
        "git")
            echo "git"
            ;;
        "curl")
            echo "curl"
            ;;
        "wget")
            echo "wget"
            ;;
        "htop")
            echo "htop"
            ;;
        "tmux")
            echo "tmux"
            ;;
        "zsh")
            echo "zsh"
            ;;
        "bat")
            case "$DISTRO_FAMILY" in
                debian) 
                    if [[ "$DISTRO" == "ubuntu" ]] && version_gt "$DISTRO_VERSION" "20.04"; then
                        echo "bat"
                    else
                        echo "batcat"
                    fi
                    ;;
                fedora|arch) echo "bat" ;;
                alpine) echo "bat" ;;
                macos) echo "bat" ;;
                *) echo "" ;;
            esac
            ;;
        "ripgrep")
            case "$DISTRO_FAMILY" in
                debian|fedora|arch|alpine) echo "ripgrep" ;;
                macos) echo "ripgrep" ;;
                *) echo "" ;;
            esac
            ;;
        "fd-find")
            case "$DISTRO_FAMILY" in
                debian) echo "fd-find" ;;
                fedora) echo "fd-find" ;;
                arch) echo "fd" ;;
                alpine) echo "fd" ;;
                macos) echo "fd" ;;
                *) echo "" ;;
            esac
            ;;
        "bottom")
            case "$DISTRO_FAMILY" in
                arch) echo "bottom" ;;
                *) echo "" ;;
            esac
            ;;
        "fontconfig")
            case "$DISTRO_FAMILY" in
                debian|fedora|arch|suse) echo "fontconfig" ;;
                alpine) echo "fontconfig" ;;
                macos) echo "" ;;  # macOS handles fonts differently
                *) echo "fontconfig" ;;
            esac
            ;;
        "xclip"|"xsel")
            case "$DISTRO_FAMILY" in
                macos) echo "" ;;  # macOS uses pbcopy/pbpaste
                *) echo "$package" ;;
            esac
            ;;
        "fzf")
            case "$DISTRO_FAMILY" in
                debian|fedora|arch|suse|alpine|macos) echo "fzf" ;;
                *) echo "fzf" ;;
            esac
            ;;
        "pipx")
            case "$DISTRO_FAMILY" in
                macos) echo "pipx" ;;
                *) echo "$package" ;;
            esac
            ;;
        "python3-venv"|"python3-full")
            case "$DISTRO_FAMILY" in
                macos) echo "" ;;  # Python3 on macOS includes venv
                *) echo "$package" ;;
            esac
            ;;
        *)
            echo "$package"
            ;;
    esac
}

upgrade_system() {
    log INFO "Upgrading system packages..."
    
    case "$PACKAGE_MANAGER" in
        apt)
            sudo apt-get update && sudo apt-get upgrade -y
            ;;
        dnf)
            sudo dnf upgrade -y
            ;;
        yum)
            sudo yum update -y
            ;;
        pacman)
            sudo pacman -Syu --noconfirm
            ;;
        zypper)
            sudo zypper update -y
            ;;
        portage)
            sudo emerge --update --deep --with-bdeps=y @world
            ;;
        apk)
            sudo apk upgrade
            ;;
        xbps)
            sudo xbps-install -Su
            ;;
        nix)
            nix-channel --update && nix-env -u
            ;;
        brew)
            brew upgrade
            ;;
        *)
            log ERROR "Unknown package manager: $PACKAGE_MANAGER"
            return 1
            ;;
    esac
}

clean_package_cache() {
    log INFO "Cleaning package cache..."
    
    case "$PACKAGE_MANAGER" in
        apt)
            sudo apt-get autoremove -y && sudo apt-get autoclean
            ;;
        dnf)
            sudo dnf clean all
            ;;
        yum)
            sudo yum clean all
            ;;
        pacman)
            sudo pacman -Sc --noconfirm
            ;;
        zypper)
            sudo zypper clean --all
            ;;
        portage)
            sudo emerge --depclean
            ;;
        apk)
            sudo apk cache clean
            ;;
        xbps)
            sudo xbps-remove -O
            ;;
        brew)
            brew cleanup
            ;;
        *)
            log WARN "Cache cleaning not implemented for $PACKAGE_MANAGER"
            ;;
    esac
}

export -f update_package_cache install_packages remove_packages
export -f is_package_installed map_package_name upgrade_system clean_package_cache