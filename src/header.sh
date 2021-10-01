#!/bin/bash
#
# Artiplunk (name had no hits on Google)
#

# Default settings that can be overridden in an install configuration:
CLEAN_ON_ABORT="no"
CLEAN_ON_SUCCESS="yes"
DEBUG="no"

# Default configuration file settings, in case directives are omitted
INIT="openrc"
BASEPKGS=('base')
KERNEL="linux"
TIMEZONE="America/New_York"
LOCALE="en_US.UTF-8"
ROOTPW=""
HOSTNAME=""
DESKTOP="none"
DISPLAY_MANAGER="none"
LOGIN_TYPE="console"
CONFIGURE_SUDO="%wheel"
EXTRA_PACKAGES=()
TABLES=()
PARTITIONS=()
CRYPTO=()
LVM_PV=()
LVM_VG=()
LVM_LV=()
FORMAT=()
MOUNT=()
SWAPON=()
USERS=()
SERVICES=()
GRUB=()
GRUB_CRYPT_DEVICE=""
VIMRC="yes"

# Array of all available steps. Normally, it should not be necessary to
# adjust this array, since steps can be skipped with -k on the CLI.
ALL_STEPS=(
    "passwords"
    "warn"
    "partitions"
    "cryptopart"
    "lvm"
    "cryptolv"
    "filesystems"
    "mount"
    "swapon"
    "bootstrap"
    "kernel"
    "fstab"
    "volkey"
    "crypttab"
    "timezone"
    "locale"
    "hostname"
    "network"
    "vim"
    "desktop"
    "extrapkgs"
    "users"
    "login"
    "services"
    "initcpio"
    "sudo"
    "grub"
    "postinstall"
)

