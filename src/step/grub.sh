#%# BEGIN step|grub
# Install and configure bootloader
#
# Handle all GRUB tasks
#%# END
step_grub() {
    local entry dev btype uuid name cname crap grubline

    log_pacman_install grub efibootmgr || abort "Failed to install GRUB"

    if [[ -n "${GRUB_CRYPT_DEVICE}" ]]; then
        cname=""
        for entry in "${CRYPTO[@]}"; do
            read -r dev name crap <<<"${entry}"
            if [[ "${dev}" == "${GRUB_CRYPT_DEVICE}" ]]; then
                cname="${name}"
                break
            fi
        done

        debug "GRUB step cname is ${cname}"
        [[ -z "${cname}" ]] && abort "GRUB_CRYPT_DEVICE is not listed in the CRYPTO table"

        uuid=$(blkid -o value -s UUID "${GRUB_CRYPT_DEVICE}")
        grubline="quiet cryptdevice=UUID=${uuid}:${cname}"
        if [[ -f "/mnt/boot/keys/${cname}" ]]; then
            grubline="${grubline} cryptkey=rootfs:/boot/keys/${cname}"
        fi

        log_run sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"${grubline}\"|" /mnt/etc/default/grub
        log_run sed -i "s/^#GRUB_ENABLE_CRYPTODISK=.*/GRUB_ENABLE_CRYPTODISK=y/" /mnt/etc/default/grub
    fi

    for entry in "${GRUB[@]}"; do
        read -r dev btype <<<"${entry}"
        case "${btype}" in
            'bios'|'mbr')
                log_chroot_run grub-install --recheck "${dev}" || abort "GRUB install failed on ${dev} (${btype})"
                ;;
            'efi')
                log_chroot_run grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
                [[ $? -ne 0 ]] && abort "GRUB install failed on ${dev} (${btype})"
                ;;
            *)
                abort "Unknown bootloader type: ${btype}"
                ;;
        esac
    done

    log_chroot_run grub-mkconfig -o /boot/grub/grub.cfg || abort "Failed to create GRUB configuration file"
}

