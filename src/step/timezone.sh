#%# BEGIN step|timezone
# Configure timezone
#
# Handle TIMEZONE
#%# END
step_timezone() {
    log_run ln -sf "/usr/share/zoneinfo/${TIMEZONE}" /mnt/etc/localtime
    log_chroot_run hwclock --systohc

    local result=$?
    if [[ ${result} -ne 0 ]]; then
        failure "Timezone was not set correctly. Fix manually after installation."
    fi
    return ${result}
}

