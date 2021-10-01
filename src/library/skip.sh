#%# BEGIN library|begin
# skip <message>
#
# Displays a message that a step will be skipped.
#
# <message>    Message to display
#%# END
skip() {
    echo -e "\e[93m[SKIP]\e[39m $1" >&2
}

