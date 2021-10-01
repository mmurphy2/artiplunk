#%# BEGIN step|cryptopart
# Encrypt physical storage devices
#
# Handles block-level LUKS containers.
#
# Handle CRYPTO (for non-mapper devices)
#%# END
step_cryptopart() {
    local entry dev name wipe key cipher size hashalg iter vkey

    for entry in "${CRYPTO[@]}"; do
        debug "Processing CRYPTO entry: ${entry}"

        # This one only deals with physical devices. LVs have to be done after LVM step has run.
        if [[ "${entry:0:4}" == "/dev" && "${entry:0:11}" != "/dev/mapper" ]]; then
            read -r dev name wipe key cipher size hashalg iter vkey <<<"${entry}"
            debug "About to prepare container ${name}"
            prepare_luks_container "${dev}" "${name}" "${wipe}" "${cipher}" "${size}" "${hashalg}" "${iter}"
        fi
    done
}

