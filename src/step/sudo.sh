#%# BEGIN step|sudo
# Install and configure sudo
#
#%# END
step_sudo() {
    if [[ -n "${CONFIGURE_SUDO}" && "${CONFIGURE_SUDO}" != "none" ]]; then
        log_pacman_install sudo || abort "Failed to install sudo package"
        log_run -o /mnt/etc/sudoers.d/10-artiplunk echo "${CONFIGURE_SUDO} ALL=(ALL) ALL"
        log_run chown root:root /mnt/etc/sudoers.d/10-artiplunk
        log_run chmod 440 /mnt/etc/sudoers.d/10-artiplunk
    fi
}

