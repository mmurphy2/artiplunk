#%# BEGIN section|optparse
# optparse
#
# Command-line option parser for Artiplunk
#%# END
do_optparse() {
    local shortopts longopts temp

    shortopts='c:CdDe:hk:l:LoOp:PrRs:S:u:x:'
    longopts='cache:,clean,debug,dry-run,end-step:,help,skip-step:,copy-log,copy-artiplunk,pack:,list:,list-categories,packed-config,'
    longopts+='proper,resume,rescue,start-step:step:unpack:example:'
    temp=$(getopt -o "${shortopts}" --long "${longopts}" -n "$0" -- "$@")
    if [[ $? -ne 0 ]]; then
        abort "Failed to parse options. Use --help for help." 2
    fi

    eval set -- "${temp}"
    unset temp

    while [[ "$1" != "--" ]]; do
        case "$1" in
            '-c'|'--cache')
                _CACHE="$2"
                shift 2
                ;;
            '-C'|'--clean')
                _MODE="clean"
                shift
                ;;
            '-d'|'--debug')
                _DEBUG="yes"
                shift
                ;;
            '-D'|'--dry-run')
                _DRY_RUN="yes"
                shift
                ;;
            '-e'|'--end-step')
                _END_STEP="$2"
                shift 2
                ;;
            '-h'|'--help')
                _MODE="help"
                shift
                ;;
            '-k'|'--skip-step')
                _SKIP_STEPS+=("$2")
                shift 2
                ;;
            '-l'|'--list')
                _MODE="list"
                _TARGET="$2"
                shift 2
                ;;
            '-L'|'--list-categories')
                _MODE="list"
                shift
                ;;
            '-o'|'--copy-log')
                _COPY_LOG="yes"
                shift
                ;;
            '-O'|'--copy-artiplunk')
                _COPY_ARTIPLUNK="yes"
                shift
                ;;
            '-p'|'--pack')
                _MODE="pack"
                _TARGET="$2"
                shift 2
                ;;
            '-P'|'--packed-config')
                _CONFIG="internal"
                shift
                ;;
            '--proper')
                _MODE="proper"
                shift
                ;;
            '-r'|'--resume')
                _RESUME="yes"
                shift
                ;;
            '-R'|'--rescue')
                _START_STEP="mount"
                _END_STEP="mount"
                shift
                ;;
            '-s'|'--start-step')
                _START_STEP="$2"
                shift 2
                ;;
            '-S'|'--step')
                _START_STEP="$2"
                _END_STEP="$2"
                shift 2
                ;;
            '-u'|'--unpack')
                _MODE="unpack"
                _TARGET="$2"
                shift 2
                ;;
            '-x'|'--example')
                _MODE="unpack"
                _TARGET="example/$2"
                shift 2
                ;;
            *)
                debug "getopt: no handler for $1"
                abort "Script bug in getopt loop"
                ;;
        esac
    done
    shift # remove --
    _ARGS="$@"
}

