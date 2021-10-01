#%# BEGIN library|item_segments
# item_segments <container> <internal_path>
#
# Counts the number of segments for an item at a specified internal path,
# placing the result on standard output. An item that is not present
# inside the container script has 0 segments.
#
# <container>       Path to the container script
# <internal_path>   Internal path of embedded item to check. The elements of
#                   this path may be separated by / or |.
#%# END
item_segments() {
    [[ $# -ne 2 ]] && return 2
    local key=$(echo "$2" | sed 's~/~|~g')
    cat "$1" | grep -c "^#%# BEGIN ${key}\$"
}

