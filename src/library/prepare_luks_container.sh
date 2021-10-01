#%# BEGIN library|prepare_luks_container
# prepare_luks_container <device> <name> <wipe> <cipher> <key_size> \
#                        <hash_algorithm> <iter_time>
#
# Prepares a new LUKS (version 1) container on the specified device. The
# device is wiped fully with random data, or if the device is being
# reused, any original LUKS header is wiped. The device is then formatted
# with a LUKS container. Finally, the crypto device is opened to make it
# ready for installation.
#
# <device>            Device node on which to create the container
# <name>              Name to use when opening the container
# <wipe>              Set to "yes" for a whole device wipe, "no" for LUKS
#                     header wipe only
# <cipher>            Cipher algorithm to use
# <key_size>          Key size in bits
# <hash_algorithm>    Hash algorithm to use
# <iter_time>         Iteration time (higher is stronger but slower to open)
#
#%# END
prepare_luks_container() {
    local wipe="header"
    local keyfile="="

    [[ "$3" == "yes" ]] && wipe="full"

    if [[ -f "${_CACHE}/lukskeys/$2.keyfile" ]]; then
        keyfile=":${_CACHE}/lukskeys/$2.keyfile"
    elif [[ -f "${_CACHE}/lukskeys/$2.passphrase" ]]; then
        keyfile+=$(cat "${_CACHE}/lukskeys/$2.passphrase")
    else
        abort "Missing keyfile or passphrase for LUKS container $2"
    fi

    prepare_crypto_device "$1" "${wipe}"
    create_luks_container "$1" "${keyfile}" --cipher "$4" --key-size "$5" --hash "$6" --iter-time "$7"
    open_luks_container "$1" "${keyfile}" "$2"
}

