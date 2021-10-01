#%# BEGIN step|filesystems
# Format filesystems
#
# Handle FORMAT
#%# END
step_filesystems() {
    local entry dev fstype label lflag args

    for entry in "${FORMAT[@]}"; do
        read -r dev fstype label <<<"${entry}"
        case "${fstype}" in   # mkfs availability on Artix live as of 11/2020
            'bfs')
                lflag="-F"
                ;;
            'cramfs'|'exfat'|'fat'|'msdos'|'vfat')
                lflag="-n"
                ;;
            'f2fs'|'reiserfs')
                lflag="-l"
                ;;
            'ntfs')
                lflag="-f -L"  # use fast format
                ;;
            *)
                lflag='-L'
                ;;
        esac

        args=(${lflag} "${label}" "${dev}")
        if [[ "${fstype}" == "minix" ]]; then
            args=("${dev}")   # minix doesn't support labels
        fi

        if [[ "${fstype}" != "swap" ]]; then
            log_run mkfs.${fstype} "${args[@]}"
        else
            log_run mkswap "${args[@]}"
        fi

        if [[ $? -eq 0 ]]; then
            success "Created ${fstype} filesystem on ${dev}"
        else
            abort "Failed to create ${fstype} filesystem on ${dev}"
        fi
    done
}

