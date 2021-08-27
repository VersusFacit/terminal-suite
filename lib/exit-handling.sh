#!/bin/bash

declare -r CLONE_DIR='./git-tmp'

err_routine () {
  local -r script=${0-unknown}
  local -r exit_status=${1-unknown}
  local -r line_number=${2-unknown}
  local -r func_name=${3-unknown}

  1>&2 echo "${script}: Error in ${func_name} on line ${line_number}"\
    "with exit status ${exit_status}"

  exit "${exit_status}"
}

exit_routine() {
  local -r exit_status="${1}"

  if [ -d "${CLONE_DIR}" ]; then
    rm -rf "${CLONE_DIR}"
  fi

  exit "${exit_status}"
}

trap 'err_routine $? ${LINENO} ${FUNCNAME[0]:-${0}}' ERR
trap 'exit_routine $?' EXIT

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
