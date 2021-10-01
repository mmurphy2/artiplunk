#%# BEGIN library|remove_item
# remove_item <container> <internal_path>
#
# Removes an item embedded inside a container script. If the item consists of
# multiple segments, all segments are removed.
#
# <container>       Path to the container script
# <internal_path>   Internal path of embedded item to remove. The elements
#                   of this path may be separated by / or |.
#
#%# END
remove_item() {
    [[ $# -ne 2 ]] && return 2
    local key=$(echo "$2" | sed 's~/~|~g')
    local data=$(cat "$1" | sed "/^#%# BEGIN ${key}\$/,/^#%# END\$/d")
    echo "${data}" > "$1"
}

