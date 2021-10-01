load "has_element.sh"

@test 'element is in an array' {
    foo=('a' 'b' 'c')
    has_element 'b' "${foo[@]}"
}

@test 'element is not in an array' {
    foo=('a' 'b' 'c')
    run has_element 'd' "${foo[@]}"
    [ "${status}" -ne 0 ]
}
