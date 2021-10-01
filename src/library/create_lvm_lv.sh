#%# BEGIN library|create_lvm_lv
# create_lvm_lv <name> <vg_name> <size>
#
# Creates an LVM logical volume named <name> of size <size>. This logical
# volume will be created inside volume group <vg_name>.
#
# <name>      Name of the newly created logical volume
# <vg_name>   Name of the LVM volume group in which to create this volume
# <size>      Size in a format accepted by lvcreate(8)
#%# END
create_lvm_lv() {
    log_run lvcreate --size "$3" --name "$1" "$2"
    if [[ $? -eq 0 ]]; then
        success "Created LVM logical volume $1"
    else
        abort "Failed to create LVM logical volume $1"
    fi
}

