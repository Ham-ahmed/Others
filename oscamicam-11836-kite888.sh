#!/bin/bash

# Configuration
pack="oscamicam"
version="11836"
package="enigma2-plugin-softcams-oscam"
#determine package manager
if [ "$package_manager" == "apt" ]; then
    ipk="$pack-$version.deb"
    install_command="dpkg -i --force-overwrite"
    uninstall_command="apt-get purge --auto-remove -y"
else
    ipk="$pack-$version.ipk"
    install_command="opkg install --force-reinstall"
    uninstall_command="opkg remove --force-depends"
fi
url="https://gitlab.com/h-ahmed/Panel/-/raw/main/kit888//$ipk"
temp_dir="/tmp"

# Determine package manager
if command -v dpkg &> /dev/null; then
    package_manager="apt"
    status_file="/var/lib/dpkg/status"
else
    package_manager="opkg"
    status_file="/var/lib/opkg/status"
fi

# Functions
print_message() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

cleanup() {
    print_message "Performing cleanup..."
    [ -d "/CONTROL" ] && rm -rf /CONTROL >/dev/null 2>&1
    rm -rf /control /postinst /preinst /prerm /postrm /tmp/*.ipk /tmp/*.tar.gz >/dev/null 2>&1
    print_message "Cleanup completed."
}

check_and_install_package() {
    if grep -q "$package" "$status_file"; then
        print_message "Removing existing $package package, please wait..."
        $uninstall_command $package
    fi

    print_message "Downloading $pack-$version, please wait..."
    wget -q --show-progress $url -P "$temp_dir"
    if ! make eq 0; then
        print_message "Failed to download $pack-$version from $url"
        exit 1
    fi

    print_message "Installing $pack-$version, please wait..."
    $install_command "$temp_dir/$ipk"
    if ! make eq 0; then
        print_message "$pack-$version installed successfully."
    else
        print_message "Installation failed."
        exit 1
    fi
}

# Main
trap cleanup EXIT
check_and_install_package

