#%# BEGIN step|users
# Create user accounts
#
# Install users
#%# END
step_users() {
    local entry uname grps pass

    for entry in "${USERS[@]}"; do
        read -r uname grps pass <<<"${entry}"
        debug "Creating user ${uname}"
        if [[ "${grps}" != "-" ]]; then
            log_chroot_run useradd -m "${uname}" -G "${grps}" || abort "Failed to create user ${uname}"
        else
            log_chroot_run useradd -m "${uname}" || abort "Failed to create user ${uname}"
        fi
    done

    log_chroot_run -r "${_CACHE}/passwords" chpasswd || abort "Failed to set user passwords"
}

