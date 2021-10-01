#%# BEGIN library|create_lvm_vg
# create_lvm_vg <name> <pv> [pv ...]
#
# Creates an LVM volume group named <name>. At least one <pv> must be
# specified.
#
# <name>   Name of the new volume group
# <pv>     First LVM physical volume (required)
# [pv]     Additional LVM physical volumes (optional)
#%# END
create_lvm_vg() {
    name="$1"
    shift
    log_run vgcreate "${name}" "$@"
    if [[ $? -eq 0 ]]; then
        success "Created LVM volume group ${name}"
    else
        abort "Failed to create LVM volume group ${name}"
    fi
}

