#%# BEGIN step|cryptolv
# Encrypt logical devices
#
# Handle CRYPTO (for mapper devices)
#%# END
step_cryptolv() {
    local entry dev name wipe key cipher size hashalg iter vkey

    for entry in "${CRYPTO[@]}"; do
        # This step handles LVM only. Block devices were done in a previous step.
        if [[ "${entry:0:11}" == "/dev/mapper" ]]; then
            read -r dev name wipe key cipher size hashalg iter vkey <<<"${entry}"
            prepare_luks_container "${dev}" "${name}" "${wipe}" "${cipher}" "${size}" "${hashalg}" "${iter}"
        fi
    done
}

