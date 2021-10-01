#%# BEGIN section|do_load_config
# do_load_config
#
# Finds and loads the configuration file, or aborts with an error if no
# configuration is available or incorrect run-time options have been given
# when running the Artiplunk executable script.
#%# END
do_load_config() {
    local cfgdata

    # An external configuration is loaded from a file, while an internal configuration is packed inside the installer. Load
    # the appropriate configuration. If no configuration is given, and install.conf doesn't yet exist inside the cache
    # directory (which might not yet itself exist), an error occurs since there is nothing to do.
    if [[ "${_CONFIG}" == "external" ]]; then
        if [[ -r "${_ARGS[0]}" ]]; then
            cfgdata=$(cat "${_ARGS[0]}")
        else
            if [[ ! -r "${_CACHE}/install.conf" ]]; then
                abort "No configuration file found. Run --help for help." 2
            fi
        fi
    else
        if has_item "${_SELF}" "config"; then
            cfgdata=$(unpack_item "${_SELF}" "config")
        else
            abort "This installer has no packed configuration."
        fi
    fi

    # Create the installer cache, where various intermediate files will be stored. Generally speaking, the cache should
    # not yet exist unless we're in an accessory mode or doing a --resume installation.
    create_cache
    case $? in
        0)
            success "Created installer cache at ${_CACHE}"
            ;;
        1)
            abort "Failed to create installer cache at ${_CACHE}"
            ;;
        2)
            if [[ "${_MODE}" == "run" ]]; then
                if [[ "${_RESUME}" != "yes" ]]; then
                    abort "Cache directory exists but --resume not specified" 2
                else
                    _STEP=$(cat "${_CACHE}/step")
                fi
            fi
            ;;
        *)
            debug "create_cache returned unexpected status"
            abort "Installer bug in do_load_config"
            ;;
    esac

    # The configuration might be stored with symmetric GPG encryption. If so, decrypt it. Either way, write the resulting
    # plaintext configuration to install.conf in the cache.
    if [[ -n "${cfgdata}" ]]; then
        if echo "${cfgdata}" | file - | grep -q GPG; then
            echo "${cfgdata}" | gpg -d - > "${_CACHE}/install.conf"
            [[ $? -ne 0 ]] && abort "Failed to decrypt configuration file"
        else
            echo "${cfgdata}" > "${_CACHE}/install.conf"
        fi
    fi

    # Finally, load the configuration. Take advantage of the fact that all variables in Bash are global unless explicitly
    # declared as local.
    . "${_CACHE}/install.conf" || abort "Configuration file invalid or not readable"
}

