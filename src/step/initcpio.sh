#%# BEGIN step|initcpio
# Create initial boot ramdisk
#
# Handle initcpio, including adding HOOKS and FILES
#%# END
step_initcpio() {
    local hooks files item

    hooks="base udev autodetect keyboard keymap modconf block"
    if [[ ${#CRYPTO[@]} -gt 0 ]]; then
        hooks="${hooks} encrypt"
    fi
    if [[ ${#LVM_LV[@]} -gt 0 ]]; then
        log_pacman_install lvm2 || abort "Failed to install the lvm2 package"
        hooks="${hooks} lvm2"
    fi

    files=""
    if [[ -d "/mnt/boot/keys" ]]; then
        for item in /mnt/boot/keys/*; do
            if [[ -n "${files}" ]]; then
                files="${files} "
            fi
            files="${files}${item:4}"
        done

        # Make the target /boot filesystem readable only by root (otherwise it is easy to steal the key from the initrd)
        chmod 700 /mnt/boot
    fi

    hooks="${hooks} filesystems fsck"
    log_run sed -i "s/^HOOKS=.*/HOOKS=\"${hooks}\"/" /mnt/etc/mkinitcpio.conf
    log_run sed -i "s~^FILES=.*~FILES=\"${files}\"~" /mnt/etc/mkinitcpio.conf
    log_chroot_run mkinitcpio -P || abort "Failed to create initial ramdisk"
}

