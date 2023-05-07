#!/usr/bin/env bash

EXIT_STATUS=0

run_tests() {
    test_single_worded_exec
    test_multiple_worded_exec
    test_manpage_section
    exit $EXIT_STATUS
}

log_failure() {
    echo "$1...FAILED"
    echo "expected: $2"
    echo "got: $3"
}

log_success() {
    echo "$1...PASSED"
}

test_single_worded_exec() {
    whatisop=$(whatis -s 1 7z)
    expected="7z(1)"
    result=$(rofi-man -t "$whatisop")
    if [ $(echo $result | grep -x -c $expected) -ne 1 ]; then
        log_failure "${FUNCNAME[0]}" $expected $result
        EXIT_STATUS=1
    else
        log_success "${FUNCNAME[0]}"
    fi
}

test_multiple_worded_exec() {
    whatisop=$(whatis -s 1 urxvt-bell-command)
    expected="urxvt-bell-command(1)"
    result=$(rofi-man -t "$whatisop")
    if [ $(echo $result | grep -x -c $expected) -ne 1 ]; then
        log_failure "${FUNCNAME[0]}" $expected $result
        EXIT_STATUS=1
    else
        log_success "${FUNCNAME[0]}"
    fi
}

test_manpage_section() {
    whatisop=$(whatis -s 8 mandb)
    expected="mandb(8)"
    result=$(rofi-man -t "$whatisop")
    if [ $(echo $result | grep -x -c $expected) -ne 1 ]; then
        log_failure "${FUNCNAME[0]}" $expected $result
        EXIT_STATUS=1
    else
        log_success "${FUNCNAME[0]}"
    fi
}

run_tests
