#%# BEGIN library|ask_pass
# ask_pass <reason>
#
# Prompts the user to enter a new password or passphrase, with a confirmation
# step. Loops if the confirmation doesn't match the original.
#
# <reason>    Reason for setting a new password
#%# END
ask_pass() {
    local preread="x"
    local confirm="y"
    while [[ "${preread}" != "${confirm}" ]]; do
        IFS= read -e -s -p "Create a new password for $1: " preread
        echo "" >&2
        IFS= read -e -s -p "Confirm the password for $1: " confirm
        echo "" >&2
        [[ "${preread}" != "${confirm}" ]] && warn "Passwords do not match. Please try again."
    done
    echo "${confirm}"
}

