#%# BEGIN step|locale
# Configure locale settings
#
# Handle LOCALE
#%# END
step_locale() {
    log_run sed -i "/^#${LOCALE} .*/s/^#//" /mnt/etc/locale.gen
    log_chroot_run /usr/bin/locale-gen || abort "Unable to generate system locale"
    log_run unpack_template "template/etc/locale.conf" /mnt/etc/locale.conf locale "${LOCALE}"
}

