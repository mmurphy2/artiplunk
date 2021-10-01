#%# BEGIN step|postinstall
# Run user-supplied postinstall script
#
# Run a user-supplied script inside the chroot
#%# END
step_postinstall() {
    local script

    if has_item "${_CACHE}/install.conf" "postinstall"; then
        script=$(unpack_item "${_CACHE}/install.conf" "postinstall")
        log_chroot_run -i "${script}" || abort "User postinstall script failed"
    fi
}

