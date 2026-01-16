#!/usr/bin/env bash

# Tasks need some formatting.
fetch_task_list() (
    placeos task --list 2>/dev/null | grep --extended-regexp '^\w+[\: ].*\|' | sed -E 's/ +/ /g' | cut -d' ' -f1
)

_placeos() {
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    case "${prev}" in
        placeos)
            case "${cur}" in
                -*)
                    COMPREPLY=( $(compgen -W "
                        -h --help
                        " -- ${cur}) )
                    ;;
                *)
                    COMPREPLY=( $(compgen -W "
                        start
                        stop
                        task
                        changelog
                        update
                        upgrade
                        uninstall
                        version
                        help
                        " -- ${cur}) )
                    ;;
            esac
            ;;
        start)
            case ${cur} in
                -*)
                    COMPREPLY=( $(compgen -W "
                        --email
                        --password
                        --application
                        --domain
                        --hard-reset
                        -v --verbose
                        -h --help
                        " -- ${cur}) )
                    ;;
            esac
            ;;
        stop)
            case ${cur} in
                -*)
                    COMPREPLY=( $(compgen -W "-v --verbose -h --help" -- ${cur}) )
                    ;;
            esac
            ;;
        task)
            case ${cur} in
                -*)
                    COMPREPLY=( $(compgen -W "--list -h --help" -- ${cur}) )
                    ;;
                *)
                    COMPREPLY=( $(compgen -W "$(fetch_task_list)" -- ${cur}) )
                    ;;
            esac
            ;;
        changelog)
            case ${cur} in
                -*)
                    COMPREPLY=( $(compgen -W "--full -h --help" -- ${cur}) )
                    ;;
            esac
            ;;
        update)
            case ${cur} in
                -*)
                    COMPREPLY=( $(compgen -W "--list --restart -v --verbose -h --help" -- ${cur}) )
                    ;;
                *)
                    COMPREPLY=( $(compgen -W "$(placeos update --list)" -- ${cur}) )
                    ;;
            esac
            ;;
        upgrade)
            case ${cur} in
                -*)
                    COMPREPLY=( $(compgen -W "--list -q --quiet -h --help" -- ${cur}) )
                    ;;
                *)
                    COMPREPLY=( $(compgen -W "$(placeos upgrade --list)" -- ${cur}) )
                    ;;
            esac
            ;;
        uninstall)
            case ${cur} in
                -*)
                    COMPREPLY=( $(compgen -W "--force -h --help" -- ${cur}) )
                    ;;
            esac
            ;;
    esac
    return 0
}

complete -F _placeos placeos
