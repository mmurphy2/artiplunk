#%# BEGIN library|next_step
# next_step [step]
#
# Finds the next enabled step in the ALL_STEPS array. If the optional [step]
# parameter is supplied, finds the next step after the specified
# [step]. Otherwise, finds the first step.
#
# [step]    Name of the current step (optional).
#
# Outputs the name of the next step (without the step_ function prefix). If no
# further steps are available, no output is produced.
#%# END
next_step() {
    local entry want_first want_next

    want_first="$1"
    want_next="no"

    for entry in "${ALL_STEPS[@]}"; do
        if [[ -z "${want_first}" ]]; then
            echo "${entry}"
            break
        elif [[ "${entry}" == "${want_first}" ]]; then
            want_next="yes"
        elif [[ "${want_next}" == "yes" ]]; then
            echo "${entry}"
            break
        fi
    done
}

