#%# BEGIN library|open_luks_container
# open_luks_container <device> <keyspec> <cryptname>
#
# Opens a LUKS container.
#
# <device>     Device node of the LUKS container
# <keyspec>    LUKS passphrase (if first character is =), or path to keyfile
#              (if first character is :), or prompt the user (if first
#              character is ?).
# <cryptname>  Device mapper name to use for the opened container
#%# END
open_luks_container() {
    local chk password
    local keyspec="$2"

    if [[ "${keyspec:0:1}" == ":" ]]; then
        log_run cryptsetup --batch-mode --key-file "${keyspec:1}" luksOpen "$1" "$3"
        chk=$?
    elif [[ "${keyspec:0:1}" == "?" ]]; then
        password=$(ask_pass_open "$1")
        log_run -i "${password}" cryptsetup --batch-mode luksOpen "$1" "$3"
    else
        log_run -i "${keyspec:1}" cryptsetup --batch-mode luksOpen "$1" "$3"
        chk=$?
    fi

    if [[ $chk -eq 0 ]]; then
        success "Opened LUKS container at /dev/mapper/$3"
    else
        abort "Failed to open LUKS container on $1"
    fi
}

