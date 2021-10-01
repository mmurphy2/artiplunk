#%# BEGIN step|login
# Configure login
#
# Configure graphical/console login
#%# END
step_login() {
    local lmpkgs

    if [[ "${DISPLAY_MANAGER}" != "none" ]]; then
        case "${DISPLAY_MANAGER}" in
            'sddm')
                lmpkgs='sddm'
                if [[ "${DESKTOP}" == "plasma" ]]; then
                    lmpkgs="${lmpkgs} sddm-kcm"
                fi
                ;;
            *)
                abort "Unsupported display manager: ${DISPLAY_MANAGER}"
                ;;
        esac

        if [[ "${INIT}" != "systemd" ]]; then
            lmpkgs="${lmpkgs} ${DISPLAY_MANAGER}-${INIT}"
        fi

        log_pacman_install ${lmpkgs}

        if [[ "${LOGIN_TYPE}" == "graphical" ]]; then
            case "${INIT}" in
                openrc)
                    log_chroot_run rc-update add "${DISPLAY_MANAGER}" default || failure "Failed to enable display manager at boot time"
                    ;;
                runit)
                    log_run ln -s "/etc/runit/sv/${DISPLAY_MANAGER}" /mnt/etc/runit/runsvdir/default/
                    [[ $? -ne 0 ]] && failure "Failed to enable display manager at boot time"
                    ;;
                s6)
                    log_chroot_run s6-rc-bundle -c /etc/s6/rc/compiled add default ${DISPLAY_MANAGER}
                    [[ $? -ne 0 ]] && failure "Failed to enable display manager at boot time"
                    ;;
                *)
                    abort "Bug in step/login.sh: unknown INIT ${INIT}"
                    ;;
            esac
        fi
    fi
}

