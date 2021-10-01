#%# BEGIN section|do_accessory
# do_accessory
#
# Accessory functionality (other than installation)
#%# END
do_accessory() {
    local name script_target result

    name=$(basename "${_SELF}")
    script_target="${_ARGS[0]:-${_SELF}}"
    debug "script_target is '${script_target}'"

    case "${_MODE}" in
        "clean")
            do_load_config
            do_cleanup
            result=$?
            if [[ ${result} -eq 0 ]]; then
                success "Cleanup complete"
            else
                failure "Cleanup failed."
                warn "Cache directory ${_CACHE} may contain secrets."
            fi
            ;;
        "help")
            name=$(basename "${_SELF}")
            filter_string "$(unpack_item "${_SELF}" 'help')" artiplunk "${name}"
            result=$?
            ;;
        "list")
            if [[ -z "${_TARGET}" ]]; then
                grep '^#%# BEGIN' "${_SELF}" | sed 's/#%# BEGIN //' | sed 's/|.*//' | sort -u
            else
                grep '^#%# BEGIN' "${_SELF}" | sed 's/#%# BEGIN //' | grep -E "^${_TARGET}(\$|\|.*)" | sed 's~|~/~g' | sort
                result=${PIPESTATUS[2]}
            fi
            ;;
        "pack")
            pack_item "${script_target}" "${_TARGET}"
            result=$?
            if [[ ${result} -eq 0 ]]; then
                success "Packed item at ${_TARGET}"
            else
                failure "Could not pack item at ${_TARGET}"
            fi
            ;;
        "proper")
            pacman --noconfirm -Sy --needed vim vim-airline vim-airline-themes vim-spell-en
            result=$?
            unpack_item "${_SELF}" template/etc/vimrc >> /etc/vimrc
            ln -sf /usr/bin/vim /usr/bin/vi
            ;;
        "unpack")
            if has_item "${script_target}" "${_TARGET}"; then
                unpack_item "${script_target}" "${_TARGET}"
                result=$?
            else
                failure "Item not found: ${_TARGET}"
                result=1
            fi
            ;;
        *)
            debug "no action ${_MODE}"
            abort "Script bug in action selector"
            ;;
    esac

    return ${result}
}

