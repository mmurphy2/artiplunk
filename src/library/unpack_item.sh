#%# BEGIN library|unpack_item
# unpack_item <container> <internal_path>
#
# Retrieves an item embedded inside a container script and dumps the result to
# standard output. The item may be stored in multiple segments within the
# container script, in which case all segments are concatenated together.
#
# <container>       Path to the container script
# <internal_path>   Internal path of embedded item to retrieve. The elements
#                   of this path may be separated by / or |.
#
#%# END
unpack_item() {
    [[ $# -ne 2 ]] && return 2
    local key=$(echo "$2" | sed 's~/~|~g')
    cat "$1" | sed -n "/^#%# BEGIN ${key}\$/,/^#%# END\$/{//b;p}" | cut -c 3-
}

