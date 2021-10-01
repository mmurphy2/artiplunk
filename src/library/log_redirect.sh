#%# BEGIN library|log_run
# Logs received standard output and simultaneously redirects it to the
# artiplunk.log file.
#
# Usage: log_redirect [options]
#
# [options] are:
# -a <file>     Append command output to <file>
# -i <string>   Use <string> as the standard input to <command>
# -o <file>     Redirect command output to <file>
# -r <file>     Use <file> as the standard input to <command>
# -s            Do not echo standard output to the screen or to the log
#
# The return status code is based upon the success of redirecting to the
# desired targets, but not to the log or standard output.
#%# END
log_redirect() {
    local shortopts temp
    local write_log="yes"
    local append_file=""
    local output_file=""
    local result=0

    shortopts='a:o:s'
    temp=$(POSIXLY_CORRECT=1 getopt -o "${shortopts}" -n "log_redirect" -- "$@")
    if [[ $? -ne 0 ]]; then
        abort "Script bug: invalid options to log_redirect"
    fi

    eval set -- "${temp}"
    unset temp

    while [[ "$1" != "--" ]]; do
        case "$1" in
            '-a')
                append_file="$2"
                shift 2
                ;;
            '-o')
                output_file="$2"
                shift 2
                ;;
            '-s')
                write_log="no"
                shift
                ;;
            *)
                debug "log_run getopt received $1"
                abort "Script bug in log_run getopt loop"
                ;;
        esac
    done
    shift

    if [[ -n "${output_file}" && -n "${append_file}" ]]; then
        if [[ "${write_log}" == "yes" ]]; then
            cat | tee "${output_file}" | tee -a "${append_file}" | tee -a "${_CACHE}/artiplunk.log"
            result=$?
        else
            (cat | tee "${output_file}") >> "${append_file}"
            result=$?
        fi
    elif [[ -n "${output_file}" ]]; then
        if [[ "${write_log}" == "yes" ]]; then
            cat | tee "${output_file}" | tee -a "${_CACHE}/artiplunk.log"
            result=$?
        else
            cat > "${output_file}"
            result=$?
        fi
    elif [[ -n "${append_file}" ]]; then
        if [[ "${write_log}" == "yes" ]]; then
            cat | tee -a "${append_file}" | tee -a "${_CACHE}/artiplunk.log"
            result=$?
        else
            cat >> "${append_file}"
            result=$?
        fi
    else
        if [[ "${write_log}" == "yes" ]]; then
            cat | tee -a "${_CACHE}/artiplunk.log"
            result=$?
        else
            cat > /dev/null   # Flush any buffers if we get a big input
        fi
    fi

    return ${result}
}

