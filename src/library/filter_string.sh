#%# BEGIN library|filter_string
# filter_string <string> [token value] [token value ...]
#
# Replaces token placeholders in strings (surrounded by %) with values. This
# logic enables templates to contain placeholders that are replaced with
# data at installation time.
#
# <string>        Input string to filter
# [token value]   Replace %token% in the input string with value
#
# Note that if a token is given without a value, the token is replaced with an
# empty string (i.e. removed). Multiple token-value pairs may be given. Neither
# token nor value strings may contain backspace characters (which should not
# be a problem for any reasonable case).
#%# END
filter_string() {
    local result="$1"
    local token value
    shift
    while [[ $# -gt 0 ]]; do
        token="$1"
        shift
        value="$1"
        shift
        # NB: the separator character in the following sed expression is a backspace. This character doesn't display
        # properly in GitHub (and might not in certain other editors... use Vim!). Backspace was chosen since the
        # value can contain arbitrary characters... but hopefully not backspace.
        result=$(echo "${result}" | sed "s\%${token}\%${value}g")
    done
    echo "${result}"
}

