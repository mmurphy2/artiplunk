#%# BEGIN step|fstab
# Create /etc/fstab
#
# Handle fstab
#%# END
step_fstab() {
    local entry dev mtpt mtopts uuid fstype pass

    for entry in "${MOUNT[@]}"; do
        read -r dev mtpt mtopts <<<"${entry}"
        uuid=$(blkid -o value -s UUID "${dev}")
        fstype=$(mount | grep "^${dev} " | awk '{print $5}')
        if [[ -z "${fstype}" ]]; then
            if [[ "${_DRY_RUN}" == "yes" ]]; then
                fstype="!dryrun"
            else
                abort "Could not determine filesystem type for ${dev}"
            fi
        fi
        pass=2
        [[ "${mtpt}" == "/" ]] && pass=1
        log_run -s -a /mnt/etc/fstab echo -e "UUID=${uuid}\t${mtpt}\t${fstype}\t${mtopts}\t1 ${pass}"
    done

    for entry in "${SWAPON[@]}"; do
        uuid=$(blkid -o value -s UUID "${entry}")
        log_run -s -a /mnt/etc/fstab echo -e "UUID=${uuid}\tswap\tswap\tdefaults\t0 0"
    done

    log_run -s -a /mnt/etc/fstab echo -e "tmpfs\t\t\t/tmp\ttmpfs\tmode=1777,rw,nosuid,nodev,relatime\t0 0"
}

