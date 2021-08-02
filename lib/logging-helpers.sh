
#
# Basic logging
#

log () {
  local -r term_width="$(tput cols)"
  printf "${@}\n" | fold -sw "${term_width}"
}

log_stderr() {
  >&2 log "$@"
}

#
# Script verbosity management
#

run_cmd_with_verbosity() {
  local -r volume_limit="${1}"
  if [[ ${VERBOSITY:-0} -ge "${volume_limit}" ]]; then
    eval "${@:2}"
  else
    >/dev/null eval "${@:2}"
  fi
}

quiet() {
  run_cmd_with_verbosity '1' "${@}"
}

very_quiet() {
  run_cmd_with_verbosity '2' "${@}"
}

log_quiet() {
  run_cmd_with_verbosity '1' "echo ${@}"
}

log_very_quiet() {
  run_cmd_with_verbosity '2' "echo ${@}"
}

#
# Write colored log messages
#

color_reset() {
  tput sgr0
}

log_info() {
  local -r color="$(tput setaf 2)"
  printf "${color}${@}\n$(color_reset)"
  tput sgr0
}

log_warn() {
  local -r color="$(tput setaf 3)"
  >&2 printf "${color}${@}\n$(color_reset)"
}

log_error() {
  local -r color="$(tput setaf 1)"
  >&2 printf "${color}${@}\n$(color_reset)"
}

