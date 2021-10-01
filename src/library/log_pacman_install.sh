#%# BEGIN library|log_pacman_install
# log_pacman_install <package> [packages]
#
# Runs pacman -S non-interactively within the chroot /mnt environment.
#%# END
log_pacman_install() {
    log_chroot_run pacman --noconfirm -S --needed "$@"
    return $?
}

