#%# BEGIN section|do_cleanup
# do_cleanup
#
# Does post-installation cleanup of the cache directory after optionally
# copying the installation log onto the target.
#%# END
do_cleanup() {
    local entry dev name wipe key cipher size hashalg iter vkey realdev

    if [[ "${_COPY_LOG}" == "yes" ]]; then
        log_run cp "${_CACHE}/artiplunk.log" /mnt/root/artiplunk.log
    fi

    if [[ "${_COPY_ARTIPLUNK}" == "yes" ]]; then
        log_run cp "${_SELF}" "/mnt/root/artiplunk-${HOSTNAME}"
        log_run cat "${_CACHE}/install.conf" | "/mnt/root/artiplunk-${HOSTNAME}" --pack config
    fi

    log_run sync

    # The gpg-agent gets started inside the chroot, holding open various files within the mount tree
    # and preventing the umount from succeeding.
    if ps ax | grep -v grep | grep -q gpg-agent; then
        log_run killall gpg-agent
    fi

    if mount | grep -q /mnt; then
        log_run umount -R /mnt || abort "Failed to unmount /mnt"
    fi

    for entry in "${SWAPON[@]}"; do
        realdev=$(readlink -e "${entry}")
        if cat /proc/swaps | grep -q "${realdev}"; then
            log_run swapoff "${entry}"
        fi
    done

    # TODO need to stop cryptolvs before stopping lvm

    if [[ ${#LVM_PV[@]} -ne 0 || ${#LVM_VG[@]} -ne 0 || ${#LVM_LV[@]} -ne 0 ]]; then
        debug "Stopping LVM volume groups"
        log_run vgchange -an
    fi

    for entry in "${CRYPTO[@]}"; do
        read -r dev name wipe key cipher size hashalg iter vkey <<<"${entry}"
        debug "Cleanup LUKS entry device ${dev} named ${name}"

        if [[ -e "/dev/mapper/${name}" ]]; then
            debug "Closing LUKS device ${dev} at /dev/mapper/${name}"
            log_run cryptsetup --batch-mode luksClose "${name}" || abort "Failed to close LUKS container ${name}"
        fi
    done

    remove_cache
}

