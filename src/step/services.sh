#%# BEGIN step|services
# Configure system services
#
# Configure boot services
#%# END
step_services() {
    local entry svc state

    for entry in "${SERVICES[@]}"; do
        read -r svc state <<<"${entry}"
        case "${INIT}" in
            openrc)
                if [[ "${state}" == "off" ]]; then
                    log_chroot_run rc-update del "${svc}" default || failure "Could not disable service ${svc}"
                else
                    log_chroot_run rc-update add "${svc}" default || failure "Could not enable service ${svc}"
                fi
                ;;
            runit)
                if [[ "${state}" == "off" ]]; then
                    log_run unlink "/mnt/etc/runit/runsvdir/default/${svc}" || failure "Could not disable service ${svc}"
                else
                    log_run ln -s "/etc/runit/sv/${svc}" "/mnt/etc/runit/runsvdir/default/${svc}"
                    [[ $? -ne 0 ]] && failure "Could not enable service ${svc}"
                fi
                ;;
            s6)
                if [[ "${state}" == "off" ]]; then
                    log_chroot_run s6-rc-bundle -c /etc/s6/rc/compiled delete default "${svc}"
                    [[ $? -ne 0 ]] && failure "Could not disable service ${svc}"
                else
                    log_chroot_run s6-rc-bundle -c /etc/s6/rc/coompiled add default "${svc}"
                    [[ $? -ne 0 ]] && failure "Could not enable service ${svc}"
                fi
                ;;
            *)
                abort "Script bug in step/services: unknown INIT ${INIT}"
                ;;
        esac
    done
}

