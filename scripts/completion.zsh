#compdef placeos

_placeos() {

_placeos_commands() {
    local -a commmands; commands=(
    'start:start the environment.' \
    'stop:stops the environment.' \
    'task:runs a task in the environment.' \
    'changelog:displays platform changelog (in markdown).' \
    'update:update the platform version.' \
    'upgrade:upgrade the Partner Environment.' \
    'uninstall:uninstalls the Partner Environment.' \
    'help:display this message.' \
    )
    _describe -t commands 'PlaceOS commmand' commands
}


local -a _start_arguments; _start_arguments=(
  '--email:email to setup an admin account for.' \
  '--password:password for created admin account.' \
  '--application:application to configure.' \
  '--domain:domain to configure.' \
  '--hard-reset:reset the environment to a default state.' \
  $verbose_args \
  $help_args \
)

local -a help_args; help_args=(
  '(-h --help)[show help]'
)

local -a verbose_args; verbose_args=(
  '(-v --verbose)'{-v,--verbose}'[write logs to STDOUT in addition to the log file]'
)

local -a _stop_arguments; _stop_arguments=(
  $verbose_args \
  $help_args \
)

local -a _task_arguments; _task_arguments=(
  '-t:--tasks:display list of available tasks.' \
  $help_args \
)

local -a _changelog_arguments; _changelog_arguments=(
  '--full:include all prior CHANGELOG entries.' \
  $help_args \
)

local -a _update_arguments; _update_arguments=(
  '--list:list the available versions.' \
  $verbose_args \
  $help_args \
)

local -a _upgrade_arguments; _upgrade_arguments=(
  '--list:lists versions of the Partner Environment.' \
  '-q:do not write command logs to STDOUT.' \
  $help_args \
)

local -a _uninstall_arguments; _uninstall_arguments=(
  '--force:skip confirmation of uninstall.' \
  $help_args \
)

_arguments -C \
  '1: :->subcommand' \
  '*:: :->task' && return 0

case $state in
  (subcommand)
    _placeos_commands && return 0
    ;;
  (task)
    case $line[1] in
      (start)
        _describe -t commands 'PlaceOS start task' _start_arguments && return 0
        ;;
      (stop)
        _describe -t commands 'PlaceOS stop task' _stop_arguments && return 0
        ;;
      (task)
        _describe -t commands 'PlaceOS task task' _task_arguments && return 0
        ;;
      (changelog)
        _describe -t commands 'PlaceOS changelog task' _changelog_arguments && return 0
        ;;
      (update)
        _describe -t commands 'PlaceOS update task' _update_arguments && return 0
        ;;
      (upgrade)
        _describe -t commands 'PlaceOS upgrade task' _upgrade_arguments && return 0
        ;;
      (uninstall)
        _describe -t commands 'PlaceOS uninstall task' _uninstall_arguments && return 0
        ;;
      (help)
        _describe -t commands 'PlaceOS help task' _help_arguments && return 0
        ;;
    esac
    ;;
esac

}

_placeos
