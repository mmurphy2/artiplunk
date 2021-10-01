#%# BEGIN library|widemsg
# widemsg <message>
#
# Displays a message that is automatically formatted to the terminal width.
#
# <message>    Message to display
#%# END
widemsg() {
    local cols=$(tput cols)

    echo -e "$@" | fmt -w ${cols} >&2
}

