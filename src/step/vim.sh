#%# BEGIN step|vim
# Install vim
#
# Install vim
#%# END
step_vim() {
    local target="${_SELF}"

    log_pacman_install vim vim-airline vim-airline-themes vim-jedi vim-spell-en vim-supertab
    [[ $? -ne 0 ]] && abort "Failed to install vim"

    log_run ln -sf /usr/bin/vim /mnt/usr/bin/vi

    if [[ "${VIMRC}" == "yes" ]]; then
        if has_item "${_CACHE}/install.conf" template/etc/vimrc; then
            target="${_CACHE}/install.conf"
        fi
        log_run -s -a /mnt/etc/vimrc unpack_item "${target}" template/etc/vimrc
    fi
}

