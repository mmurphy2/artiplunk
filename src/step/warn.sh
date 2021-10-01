#%# BEGIN step|warn
# Warn the user that changes are about to be made.
#
#%# END
step_warn() {
    if [[ "${_DRY_RUN}" != "yes" ]]; then
        local cols=$(tput cols)

        center "WARNING"
        widemsg "The installer is about to make changes to your system, which may result in data loss. This is a non-interactive installer, and you will not be prompted for confirmation again!\n"
        countdown 15 "Press CTRL+C within %COUNT% seconds to abort"
    fi
}

