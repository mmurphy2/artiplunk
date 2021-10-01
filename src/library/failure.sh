#%# BEGIN library|failure
# failure <message>
#
# Displays a non-terminating failure message.
#
# <message>    Failure message
#%# END
failure() {
    echo -e "\e[91m[FAIL]\e[39m $1" >&2
}

