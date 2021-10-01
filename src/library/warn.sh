#%# BEGIN library|warn
# warn <message>
#
# Displays a warning message.
#
# <message>    Warning message
#%# END
warn() {
    echo -e "\e[93m[WARN]\e[39m $1" >&2
}

