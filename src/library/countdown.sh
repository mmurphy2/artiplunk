#%# BEGIN library|countdown
# countdown <timeout> <message>
#
# Displays a countdown message, advising CTRL+C to abort a process.
#
# <timeout>    Timeout in seconds
# <message>    Message to display. The text %COUNT% will be replaced with the counter value.
#%# END
countdown() {
    local count=$1
    local cols=$(tput cols)
    local len padsize msg

    while [[ ${count} -gt 0 ]]; do
        msg=$(echo "$2" | sed "s/%COUNT%/${count}/")
        len=${#msg}
        padsize=$(( (cols - len) / 2))

        printf '%*s\r' ${cols} >&2
        printf '%*s' ${padsize} >&2
        echo -ne "\e[93m${msg}\e[39m\r" >&2
        sleep 1
        count=$(( count - 1 ))
    done

    printf '%*s\r' ${cols} >&2
}

