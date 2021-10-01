#%# BEGIN library|has_item
# has_item <container> <internal_path>
#
# Determines whether or not a given container script has an item embedded at
# an internal path.
#
# <container>       Path to the container script
# <internal_path>   Internal path of embedded item to check. The elements of
#                   this path may be separated by / or |.
#
# Returns 0 if any segments of the item are found inside the container, 1 if
# no segments are found, and 2 if called improperly.
#%# END
has_item() {
    [[ $# -ne 2 ]] && return 2
    local key=$(echo "$2" | sed 's~/~|~g')
    local result=1
    if cat "$1" | grep -q "^#%# BEGIN ${key}\$"; then
        result=0
    fi
    return ${result}
}

