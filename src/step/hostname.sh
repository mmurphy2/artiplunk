#%# BEGIN step|hostname
# Set system hostname
#
# Handle HOSTNAME
#%# END
step_hostname() {
    log_run -o /mnt/etc/hostname echo "${HOSTNAME}"
    log_run -a /mnt/etc/hosts echo -e "127.0.1.1\t${HOSTNAME}"
}

