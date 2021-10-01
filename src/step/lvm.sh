#%# BEGIN step|lvm
# Configure logical volume manager
#
# Handle LVM_PV LVM_VG LVM_LV
#%# END
step_lvm() {
    local entry vg pvs lv size

    # Suppress LVM tools trying to be "helpful" with spam messages
    export LVM_SUPPRESS_FD_WARNINGS=1

    # Handle physical volumes first
    for entry in "${LVM_PV[@]}"; do
        create_lvm_pv "${entry}"
    done

    # Create the volume groups
    for entry in "${LVM_VG[@]}"; do
        read -r vg pvs <<<"${entry}"
        create_lvm_vg "${vg}" ${pvs}
    done

    # Create the logical volumes
    for entry in "${LVM_LV[@]}"; do
        read -r lv vg size <<<"${entry}"
        create_lvm_lv "${lv}" "${vg}" "${size}"
    done
}

