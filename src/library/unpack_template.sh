#%# BEGIN library|unpack_template
# unpack_template <internal_path> <save_as> [name value] [...]
#
# Unpacks a template and processes any placeholder substitutions using
# the list of [name value] pairs. The template is first requested from
# the configuration file. If that file is not present, or if the
# template is not found packed in the configuration, then the template
# is requested from the installer. Since a missing template could
# result in a non-bootable system, an abort is triggered if the template
# is not ultimately found.
#%# END
unpack_template() {
    local path="$1"
    local save="$2"
    shift 2

    if has_item "${_CACHE}/install.conf" "${path}"; then
        filter_string "$(unpack_item "${_CACHE}/install.conf" "${path}")" "$@" > "${save}"
    elif has_item "${_SELF}" "${path}"; then
        filter_string "$(unpack_item "${_SELF}" "${path}")" "$@" > "${save}"
    else
        abort "Required item not found: ${path}"
    fi
}

