#%# BEGIN library|pack_item
# pack_item <container> <internal_path>
#
# Packs an item, read from standard input, into the specified container script
# at the specified internal path. If the item has the same internal path as an
# existing item, the item becomes a second segment of the existing item (i.e.
# both items are concatenated together on unpack). If replacement of an
# existing item is desired, run remove_item on the internal path first.
#
# <container>       Path to the container script
# <internal_path>   Internal path at which to embed the item. The elements of
#                   this path may be separated by / or |.
#
#%# END
pack_item() {
    [[ $# -ne 2 ]] && return 2
    local key=$(echo "$2" | sed 's~/~|~g')
    echo "#%# BEGIN ${key}" >> "$1" || return 1
    cat | sed 's/^/# /' >> "$1"
    echo "#%# END" >> "$1"
}

