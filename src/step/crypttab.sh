#%# BEGIN step|crypttab
# Create /etc/crypttab
#
# Handle crypttab
#%# END
step_crypttab() {
    local entry dev name wipe key cipher size hashalg iter vkey

    for entry in "${CRYPTO[@]}"; do
        read -r dev name wipe key cipher size hashalg iter vkey <<<"${entry}"
        if [[ "${vkey}" == "yes" ]]; then
            vkey="/boot/keys/${name}"
        else
            vkey="none"
        fi
        log_run -a /mnt/etc/crypttab echo -e "${name}\t${dev}\t${vkey}\tluks"
    done
}

