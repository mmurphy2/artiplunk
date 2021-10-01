#%# BEGIN library|create_cache
# Creates the cache directory, as specified in the _CACHE setting.
#
# Returns 0 if a directory is newly created, 1 if creation fails, or 2 if
# the directory already exists.
#%# END
create_cache() {
    [[ -d "${_CACHE}" ]] && return 2
    mkdir -p "${_CACHE}" || return 1
    return 0
}

