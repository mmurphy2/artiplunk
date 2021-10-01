#%# BEGIN section|do_run_steps
# do_run_steps
#
# Runs the steps of the installation.
#%# END
do_run_steps() {
    local status=0
    local final_status=0
    local want_stop="no"
    local desc

    if [[ -n "${_START_STEP}" ]]; then
        _STEP="${_START_STEP}"
    fi

    # Separate "if" since _STEP could be set in do_load_config
    if [[ -z "${_STEP}" ]]; then
        _STEP=$(next_step)
    fi

    debug "Before loop: _STEP is ${_STEP}, _END_STEP is ${_END_STEP}"
    while [[ -n "${_STEP}" && "${want_stop}" == "no" ]]; do
        desc=$(unpack_item "${_SELF}" "step|${_STEP}" | head -n 1)
        if has_element "${_STEP}" "${_SKIP_STEPS[@]}"; then
            skip "${desc} (${_STEP})"
        else
            echo "${_STEP}" > "${_CACHE}/step"
            begin "${desc} (${_STEP})"
            "step_${_STEP}"
            status=$?
            if [[ ${status} -eq 0 ]]; then
                success "${desc} (${_STEP})"
            else
                failure "${desc} (${_STEP})"
                final_status=${status}
            fi
        fi
        echo "" >&2
        [[ "${_STEP}" == "${_END_STEP}" ]] && want_stop="yes"
        _STEP=$(next_step "${_STEP}")
    done
    debug "After loop: _STEP is ${_STEP}"

    return ${final_status}
}

