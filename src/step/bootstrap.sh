#%# BEGIN step|bootstrap
# Bootstraps the system by installing the specified base packages.
#
# Handle BASEPKGS
#%# END
step_bootstrap() {
    local initpkg

    case "${INIT}" in
        openrc)
            initpkg="openrc"
            ;;
        runit)
            initpkg="runit elogind-runit"
            ;;
        s6)
            initpkg="s6 elogind-s6"
            ;;
        *)
            warn "Invalid INIT: ${INIT}"
            note "Substituting openrc"
            initpkg="openrc"
            INIT="openrc"
            ;;
    esac

    log_run mkdir -p /mnt/var/lib/pacman/{local,sync}
    log_run chmod 755 /mnt/var/lib/pacman

    log_run pacman --noconfirm -r /mnt -Sy "${BASEPKGS[@]}" ${initpkg} || abort "Failed pacman base install"
    log_chroot_run pacman-key --init || abort "Failed to initialize pacman keys"
    log_chroot_run pacman-key --populate archlinux artix || abort "Failed to populate pacman keys"
    log_chroot_run pacman -Syy || abort "Failed to initialize pacman repositories"
}

