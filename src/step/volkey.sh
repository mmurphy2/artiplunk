#%# BEGIN step|volkey
# Generate volume keys
#
# Handle volume key generation for auto-unlock LUKS from GRUB
#%# END
step_volkey() {
    local entry dev name wipe key cipher size hashalg iter vkey passphrase

    for entry in "${CRYPTO[@]}"; do
        read -r dev name wipe key cipher size hashalg iter vkey <<<"${entry}"
        if [[ "${vkey}" == "yes" ]]; then
            note "Generating key for ${dev}"
            if [[ ! -d /mnt/boot/keys ]]; then
                log_run mkdir -p /mnt/boot/keys
                log_run chmod 600 /mnt/boot/keys
            fi
            log_run dd bs=512 count=4 if=/dev/urandom of="/mnt/boot/keys/${name}" iflag=fullblock status=progress
            log_run chmod 400 "/mnt/boot/keys/${name}"

            if [[ -f "${_CACHE}/lukskeys/${name}.keyfile" ]]; then
                log_run cryptsetup --batch-mode --key-file "${_CACHE}/lukskeys/${name}.keyfile" luksAddKey "${dev}" "/mnt/boot/keys/${name}"
            elif [[ -f "${_CACHE}/lukskeys/${name}.passphrase" ]]; then
                passphrase=$(cat "${_CACHE}/lukskeys/${name}.passphrase")
                log_run -i "${passphrase}" cryptsetup luksAddKey "${dev}" "/mnt/boot/keys/${name}"
            else
                abort "Missing keyfile or passphrase for LUKS container ${name}"
            fi
        fi
    done
}

