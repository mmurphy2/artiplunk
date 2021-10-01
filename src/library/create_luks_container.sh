#%# BEGIN library|create_luks_container
# create_luks_container <device> <keyspec> [options]
#
# Creates a new LUKS (version 1) container on the specified device.
#
# <device>   Device node on which to create the container
# <keyspec>  Passphrase (if first character is =) or path to keyfile (if
#            first character is :)
# [options]  Additional options to pass to cryptsetup(8)
#%# END
create_luks_container() {
    local chk
    local dev="$1"
    shift
    local keyspec="$1"
    shift

    if [[ "${keyspec:0:1}" == ":" ]]; then
        log_run cryptsetup --batch-mode --verbose "$@" --use-random luksFormat --type luks1 "${dev}" "${keyspec:1}"
        chk=$?
    else
        log_run -i "${keyspec:1}" cryptsetup --batch-mode --verbose "$@" --use-random luksFormat --type luks1 "${dev}"
        chk=$?
    fi

    if [[ $chk -eq 0 ]]; then
        success "Created LUKS container on ${dev}"
    else
        abort "Failed to create LUKS container on ${dev}"
    fi
}

