#%# BEGIN library|create_lvm_pv
# create_lvm_pv <device>
#
# Creates an LVM physical volume on a device.
#
# <device>   Device node on which to create the volume
#%# END
create_lvm_pv() {
    log_run pvcreate "$1"
    if [[ $? -eq 0 ]]; then
        success "Created LVM physical volume on $1"
    else
        abort "Failed to create LVM physical volume on $1"
    fi
}

