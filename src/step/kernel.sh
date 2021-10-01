#%# BEGIN step|kernel
# Install the kernel
#
# Handle KERNEL
#%# END
step_kernel() {
    # NOTE leave ${KERNEL} unquoted so multiple packages can be specified if needed
    log_pacman_install ${KERNEL} linux-firmware
}

