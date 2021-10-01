#%# BEGIN step|swapon
# Enable swap
#
# Handle SWAPON
#%# END
step_swapon() {
    local dev

    for dev in "${SWAPON[@]}"; do
        log_run swapon "${dev}"
    done
}

