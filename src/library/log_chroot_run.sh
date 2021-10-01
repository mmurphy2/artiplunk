#%# BEGIN library|log_chroot_run
# Runs a command inside the /mnt chroot and appends its output to a log.
#
# Each command is run, redirecting its standard error output to its standard
# output stream, both of which are logged to artiplunk.log in the cache
# directory.
#
# If _DRY_RUN is yes, displays (and logs) the command that would be run, but
# does not actually run the command.
#
# Usage: log_chroot_run [options] command [args]
#
# [options] are:
# -a <file>     Append command output to <file>
# -i <string>   Use <string> as the standard input to <command>
# -o <file>     Redirect command output to <file>
# -r <file>     Use <file> as the standard input to <command>
# -s            Do not echo standard output to the screen or to the log
#
# Returns the status code returned by the original command.
#%# END
log_chroot_run() {
    local shortopts temp
    local opts=()

    shortopts='a:i:o:r:s'
    temp=$(POSIXLY_CORRECT=1 getopt -o "${shortopts}" -n "log_chroot_run" -- "$@")
    if [[ $? -ne 0 ]]; then
        abort "Script bug: invalid options to log_chroot_run"
    fi

    eval set -- "${temp}"
    unset temp

    while [[ "$1" != "--" ]]; do
        case "$1" in
            '-a')
                opts+=('-a' "$2")
                shift 2
                ;;
            '-i')
                opts+=('-i' "$2")
                shift 2
                ;;
            '-o')
                opts+=('-o' "$2")
                shift 2
                ;;
            '-r')
                opts+=('-r' "$2")
                shift 2
                ;;
            '-s')
                opts+=('-s')
                shift
                ;;
            *)
                debug "log_chroot_run getopt received $1"
                abort "Script bug in log_chroot_run getopt loop"
                ;;
        esac
    done
    shift

    log_run "${opts[@]}" chroot /mnt "$@"
    return $?
}

