#%# BEGIN step|partitions
# Partition storage devices
#
# Handle TABLES, PARTITIONS
#%# END
step_partitions() {
    local tabitem dev ttype fname partitem pdev size ptype pfound sfile
    local mapdata=$(unpack_item "${_SELF}" "resource|partition_types")

    # Generate the sfdisk scripts first
    mkdir -p "${_CACHE}/sfdisk"
    for tabitem in "${TABLES[@]}"; do
        read -r dev ttype <<<"${tabitem}"
        debug "Processing table ${dev} : ${ttype}"
        fname=$(echo "${dev}" | sed 's~/~_~g')
        echo "label: ${ttype}" > "${_CACHE}/sfdisk/${fname}"
        for partitem in "${PARTITIONS[@]}"; do
            read pdev size ptype <<<"${partitem}"
            pfound=$(echo "${mapdata}" | grep "${ptype}")
            if [[ -n "${pfound}" ]]; then
                if [[ "${ttype}" == "dos" ]]; then
                    ptype=$(echo "${pfound}" | awk '{print $2}')
                else
                    ptype=$(echo "${pfound}" | awk '{print $3}')
                fi
            fi
            if [[ "${size}" == "fill" ]]; then
                echo "${pdev} : type=${ptype}" >> "${_CACHE}/sfdisk/${fname}"
            else
                echo "${pdev} : size=${size},type=${ptype}" >> "${_CACHE}/sfdisk/${fname}"
            fi
        done
    done

    # Run the sfdisk scripts to partition
    for sfile in "${_CACHE}/sfdisk"/*; do
        fname=$(basename "${sfile}")
        dev=$(echo "${fname}" | sed 's~_~/~g')
        log_run -r "${sfile}" sfdisk "${dev}" || abort "Failed to partition ${dev}"
    done
}

