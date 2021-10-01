#%# BEGIN step|desktop
# Install desktop environment
#
# Install a desktop environment
#%# END
step_desktop() {
    local tgt pkgs

    if [[ -n "${DESKTOP}" && "${DESKTOP}" != "none" ]]; then
        if has_item "${_CACHE}/install.conf" "desktop/${DESKTOP}"; then
            tgt="${_CACHE}/install.conf"
        elif has_item "${_SELF}" "desktop/${DESKTOP}"; then
            tgt="${_SELF}"
        else
            abort "Unknown desktop environment: ${DESKTOP}"
        fi

        pkgs=$(unpack_item "${tgt}" "desktop/${DESKTOP}" | grep -v '^#' | tr '\n' ' ')
        log_pacman_install ${pkgs} || abort "Failed to install desktop environment ${DESKTOP}"
    fi
}

