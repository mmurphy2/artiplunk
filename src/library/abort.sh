#%# BEGIN library|abort
# abort <message> [status]
#
# Aborts the installation. Cleans the cache directory only if the variable
# CLEAN_ON_ABORT="yes".
#
# <message>    Abort message
# [status]     Optional exit status (default 1)
#%# END
abort() {
    echo -e "\e[91m[ABORT]\e[39m $1" >&2
    if [[ "${CLEAN_ON_ABORT}" == "yes" ]]; then
        remove_cache
    else
        if [[ -d "${_CACHE}" ]]; then
            warn "Leftover cache directory ${_CACHE} may contain secrets."
        fi
    fi
    local status=1
    [[ -n "$2" ]] && status=$2
    exit ${status}
}

