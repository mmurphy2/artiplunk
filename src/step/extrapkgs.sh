#%# BEGIN step|extrapkgs
# Install extra packages
#
# Install extra packages
#%# END
step_extrapkgs() {
    local item pkgs

    if has_item "${_CACHE}/install.conf" extrapkgs; then
        pkgs=$(unpack_item "${_CACHE}/install.conf" "extrapkgs" | grep -v '^#' | tr '\n' ' ')
    fi

    for item in "${EXTRA_PACKAGES[@]}"; do
        pkgs="${pkgs} ${item}"
    done

    log_pacman_install ${pkgs} || abort "Failed to install requested extra packages"
}

