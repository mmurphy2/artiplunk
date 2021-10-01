#%# BEGIN library|prepare_crypto_device
# prepare_crypto_device <device> <method>
#
# Performs a cryptographic wipe of <device>, filling it with random data to
# hide the starting and ending locations of contained objects. If the device
# was previously used as a cryptographic container, it is sufficient to
# wipe the LUKS header instead. This option may be specified with the "header"
# method.
#
# <device>   Device node on which to perform the cryptographic wipe
# <method>   One of: full, header. Default is full (wipe whole device).
#%# END
prepare_crypto_device() {
    if [[ "$2" != "header" ]]; then
        note "Wiping $1 with random data. This could take a while."
        log_run cryptsetup --batch-mode open --type plain --key-file /dev/urandom "$1" to_be_wiped
        [[ $? -ne 0 ]] && abort "Disk wipe failed."
        log_run dd if=/dev/zero of=/dev/mapper/to_be_wiped status=progress
        sync
        sleep 5
        log_run cryptsetup --batch-mode close to_be_wiped
    else
        note "Wiping LUKS header from $1."
        log_run dd if=/dev/urandom of="$1" bs=512 count=40960 status=progress
        [[ $? -ne 0 ]] && abort "Failed to wipe LUKS header."
    fi
}

