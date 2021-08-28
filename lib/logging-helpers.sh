#!/bin/bash -e

# Set colors for STDOUT
if [ -t 1 ]; then
  declare -r TTY_STDOUT='true'
else
  declare -r TTY_STDOUT='false'
fi

readonly GRN="$([ "$TTY_STDOUT" = 'true' ] && tput setaf 2)"
readonly CLR="$([ "$TTY_STDOUT" = 'true' ] && tput sgr0)"

# Set colors for STDERR
if [ -t 2 ]; then
  declare -r TTY_STDERR='true'
else
  declare -r TTY_STDERR='false'
fi

readonly ERR_RED="$([ "$TTY_STDERR" = 'true' ] && tput setaf 1)"
readonly ERR_YLW="$([ "$TTY_STDERR" = 'true' ] && tput setaf 3)"
readonly ERR_CLR="$([ "$TTY_STDERR" = 'true' ] && tput sgr0)"

timestamp() {
  printf "[%s]" "$(date +"%y-%m-%d %T")"
}

log () {
  >&3 printf "%-5s%s\n" 'LOG' "$(timestamp) ${*}" | fold -sw "$(tput cols)"
}

log_info() {
  printf "%s%-5s%s\n" "${GRN}" 'INFO' "$(timestamp) ${*}${CLR}" \
    | fold -sw "$(tput cols)"
}

log_warn() {
  >&2 printf "%s%-5s%s\n" "${ERR_YLW}" 'WARN' \
    "$(timestamp) ${*}${ERR_CLR}" | fold -sw "$(tput cols)"
}

log_error() {
  >&2 printf "%s%-5s%s\n" "${ERR_RED}" 'ERR' \
    "$(timestamp) ${*}${ERR_CLR}" | fold -sw "$(tput cols)"
}

quiet_popd() {
  popd >/dev/null
}

quiet_pushd() {
  pushd "${*}" >/dev/null
}
