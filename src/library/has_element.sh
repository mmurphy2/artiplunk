#%# BEGIN library|has_element
# has_element <item> <"${array[@]}">
#
# Determines whether or not an array contains an item.
#
# <item>            Value of the item
# <"${array[@]}">   Expand the array as the rest of the function parameters
#%# END
has_element() {
    local result=1
    local item="$1"
    shift

    while [[ $# -gt 0 ]]; do
        if [[ "${item}" == "$1" ]]; then
            result=0
            break
        fi
        shift
    done

    return ${result}
}

