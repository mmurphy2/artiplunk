#%# BEGIN library|ask_pass_open
# ask_pass_open <reason>
#
# Prompts the user to enter the password or passphrase to open a LUKS
# container or other secured item.
#
# <reason>    Reason for asking for the password
#%# END
ask_pass_open() {
    local password=""
    read -e -s -p "Enter password/passphrase for $1: " password
    echo "" >&2
    echo "${password}"
}

