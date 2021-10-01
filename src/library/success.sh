#%# BEGIN library|success
# success <message>
#
# Displays a success message.
#
# <message>    Success message
#%# END
success() {
    echo -e "\e[92m[OK]\e[39m $1" >&2
}

