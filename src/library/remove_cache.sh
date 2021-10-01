#%# BEGIN library|remove_cache
# Removes the cache directory, as specified in the _CACHE setting.
#%# END
remove_cache() {
    [[ "${_CACHE}" != "/" ]] && rm -rf "${_CACHE}"
}

