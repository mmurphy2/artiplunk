#%# BEGIN library|note
# note <message>
#
# Displays a notation.
#
# <message>    Message to display
#%# END
note() {
    echo -e "\e[96m[NOTICE]\e[39m $1" >&2
}

