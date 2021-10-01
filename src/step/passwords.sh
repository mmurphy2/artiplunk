#%# BEGIN step|passwords
# Gather passwords and credentials
#
# In this step, any missing passwords for LUKS volumes, the root user, and any
# created users are collected. By performing the collection step early, the
# rest of the installation should be non-interactive.
#%# END
step_passwords() {
    local entry dev name state key cipher size hashalg itertime vkey uname groups pass
    if [[ ${#CRYPTO[@]} -gt 0 ]]; then
        mkdir -p "${_CACHE}/lukskeys"
        for entry in "${CRYPTO[@]}"; do
            read -r dev name state key cipher size hashalg itertime vkey <<<"${entry}"
            case "${key:0:1}" in
                ':')
                    cp "${key:1}" "${_CACHE}/lukskeys/${name}.keyfile"
                    [[ $? -ne 0 ]] && abort "Unable to read LUKS keyfile ${key:1}"
                    ;;
                '=')
                    echo "${key:1}" > "${_CACHE}/lukskeys/${name}.passphrase"
                    ;;
                '?')
                    ask_pass "LUKS container ${name}" > "${_CACHE}/lukskeys/${name}.passphrase"
                    ;;
                *)
                    abort "Invalid value for LUKS key for ${name}"
                    ;;
            esac
        done
    fi

    if [[ -z "${ROOTPW}" ]]; then
        ROOTPW=$(ask_pass "root")
    fi

    touch "${_CACHE}/passwords"
    chmod 600 "${_CACHE}/passwords"
    echo "root:${ROOTPW}" > "${_CACHE}/passwords"

    for entry in "${USERS[@]}"; do
        read -r uname groups pass <<<"${entry}"
        grep -q "^${uname}:.*" "${_CACHE}/passwords"
        if [[ $? -ne 0 ]]; then
            if [[ -z "${pass}" ]]; then
                pass=$(ask_pass "${uname}")
            fi
            echo "${uname}:${pass}" >> "${_CACHE}/passwords"
        fi
    done
}

