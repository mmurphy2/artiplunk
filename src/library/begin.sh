#%# BEGIN library|begin
# begin <message>
#
# Displays a message for the beginning of a step.
#
# <message>    Message to display
#%# END
begin() {
    echo -e "\e[96m[BEGIN]\e[39m $1" >&2
}

