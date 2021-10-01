#%# BEGIN step|mount
# Mount target filesystems
#
# Handle MOUNT
#%# END
step_mount() {
    local entry dev name wipe key extra keyspec
    local label vg vgch
    local mtpt mtopts

    # To enable resumption at the mount step for rescue mode, check that all the required device nodes are available,
    # and take any necessary steps to make them available. Begin with partition-level crypto devices.
    for entry in "${CRYPTO[@]}"; do
        read -r dev name wipe key extra <<<"${entry}"
        debug "Pre-mount CRYPTO device ${dev}"
        if [[ "${dev:0:4}" == "/dev" && "${dev:0:11}" != "/dev/mapper" ]]; then
            if [[ ! -e "/dev/mapper/${name}" ]]; then
                if [[ -r "${_CACHE}/lukskeys/${name}.keyfile" ]]; then
                    keyspec=":${_CACHE}/lukskeys/${name}.keyfile"
                elif [[ -r "${_CACHE}/lukskeys/${name}.passphrase" ]]; then
                    keyspec="="
                    keyspec+=$(cat "${_CACHE}/lukskeys/${name}.passphrase")
                else
                    keyspec="${key}"
                fi
                debug "About to open LUKS container ${dev} at ${name}"
                open_luks_container "${dev}" "${keyspec}" "${name}"
            fi
        fi
    done

    # Check that any LVM logical volumes are active. If any are missing, run vgchange to activate them.
    vgch="no"
    for entry in "${LVM_LV[@]}"; do
        read -r label vg extra <<<"${entry}"
        if [[ ! -e "/dev/mapper/${vg}-${label}" ]]; then
            if [[ "${vgch}" == "no" ]]; then
                log_run vgchange -ay
                vgch="yes"
            else
                abort "Device /dev/mapper/${vg}-${label} not found"
            fi
        fi
    done

    # Check and activate any LUKS containers inside logical volumes
    for entry in "${CRYPTO[@]}"; do
        read -r dev name wipe key extra <<<"${entry}"
        if [[ "${dev:0:11}" == "/dev/mapper" ]]; then
            if [[ ! -e "${dev}" ]]; then
                if [[ -r "${_CACHE}/lukskeys/${name}.keyfile" ]]; then
                    keyspec=":${_CACHE}/lukskeys/${name}.keyfile"
                elif [[ -r "${_CACHE}/lukskeys/${name}.passphrase" ]]; then
                    keyspec="="
                    keyspec+=$(cat "${_CACHE}/lukskeys/${name}.passphrase")
                else
                    keyspec="${key}"
                fi
                open_luks_container "${dev}" "${keyspec}" "${name}"
            fi
        fi
    done

    # Now mount the target system
    for entry in "${MOUNT[@]}"; do
        read -r dev mtpt mtopts <<<"${entry}"
        log_run mkdir -p "/mnt${mtpt}" || abort "Failed to create mount point /mnt${mtpt}"
        log_run mount -o "${mtopts}" "${dev}" "/mnt${mtpt}" || abort "Failed to mount device ${dev} at /mnt${mtpt}"
    done

    # Create requisite directories inside the target system, if they do not already exist
    log_run mkdir -p /mnt/{dev,proc,run,sys,tmp} || abort "Failed to create base directories in new root"
    log_run chmod 755 /mnt/{dev,proc,run,sys}
    log_run chmod 1777 /mnt/tmp

    # Bind mount the various special filesystems
    log_run mount -t proc -o rw,nosuid,nodev,noexec,relatime /proc /mnt/proc || abort "Failed to mount /proc in new root"
    log_run mount -o bind /dev /mnt/dev || abort "Failed to bind /dev"
    log_run mkdir -p /mnt/dev/pts
    log_run mount -o bind /dev/pts /mnt/dev/pts || abort "Failed to bind /dev/pts"
    log_run mount -o bind /sys /mnt/sys || abort "Failed to bind /sys"
    log_run mount -o bind /run /mnt/run || abort "Failed to bind /run"

    # Ensure that /tmp is on tmpfs, so that persistent junk doesn't end up on the target
    log_run mount -t tmpfs -o mode=1777,rw,nosuid,nodev,relatime tmpfs /mnt/tmp || abort "Failed to mount tmpfs on /mnt/tmp"
}

