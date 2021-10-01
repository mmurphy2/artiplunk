#%# BEGIN main
# Artiplunk main script logic.
#
# The main script uses functions from the util/ group to keep the core logic
# as clean as possible.
#%# END

# Private variables should not be used in the installer config file, unless
# overriding a built-in function.
#
_SELF=$(readlink -e "$0")
_CACHE="/tmp/artiplunk"
_MODE="run"
_DEBUG="no"
_TARGET=""
_CONFIG="external"
_RESUME="no"
_ARGS=
_STATUS=0
_STEP=""
_START_STEP=""
_END_STEP=""
_SKIP_STEPS=()
_DRY_RUN="no"
_COPY_LOG="no"
_COPY_ARTIPLUNK="no"


do_optparse "$@"
debug "Entering mode '${_MODE}' target: '${_TARGET}' args: '${_ARGS[@]}'"
if [[ "${_MODE}" != "run" ]]; then
    do_accessory
    _STATUS=$?
else
    do_load_config
    do_run_steps
    _STATUS=$?
    if [[ -z "${_END_STEP}" ]]; then
        if [[ ${_STATUS} -eq 0 ]]; then
            success "Installation complete."
            if [[ "${CLEAN_ON_SUCCESS}" == "yes" ]]; then
                do_cleanup
            else
                note "Skipping cleanup steps"
                warn "Leftover cache directory ${_CACHE} may contain secrets."
            fi
        else
            failure "One or more installation steps failed."
            warn "Leftover cache directory ${_CACHE} may contain secrets."
        fi
    else
        note "Ended after step ${_END_STEP}"
        warn "Leftover cache directory ${_CACHE} may contain secrets."
    fi
fi

exit ${_STATUS}

