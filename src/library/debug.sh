#%# BEGIN library|debug
# debug <message>
#
# Displays a debug message only when DEBUG is "yes".
#
# <message>    Debug message
#%# END
debug() {
    if [[ "${_DEBUG}" == "yes" ]]; then
        echo -e "\e[95m[DEBUG]\e[39m $1" >&2
    fi
}

