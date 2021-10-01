#%# BEGIN step|network
# Configure network for first boot
#
# Handle NetworkManager etc.
#%# END
step_network() {
    log_pacman_install networkmanager networkmanager-${INIT}
    # TODO need to add logic to edit connection files to allow for static IP, etc.
    # For now, we just do dhcp
    # Enable at boot
    case "${INIT}" in
        'openrc')
            log_chroot_run rc-update add NetworkManager default
            ;;
        'runit')
            log_run ln -s /etc/runit/sv/NetworkManager /mnt/etc/runit/runsvdir/default/
            ;;
        's6')
            log_chroot_run s6-rc-bundle -c /etc/s6/rc/compiled add default NetworkManager
            ;;
        *)
            abort "Script bug in step_network: init ${INIT} not found"
            ;;
    esac
}

