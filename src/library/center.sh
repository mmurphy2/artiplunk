#%# BEGIN library|center
# center <message>
#
# Displays a centered message in yellow, with blank lines above and below.
#
# <message>    Message to display
#%# END
center() {
    local text="$1"
    local len=${#text}
    local cols=$(tput cols)
    local padsize=$(( (cols - len) / 2 ))

    echo >&2
    printf '%*s' ${padsize} >&2
    echo -e "\e[93m$1\e[39m" >&2
    echo >&2
}

