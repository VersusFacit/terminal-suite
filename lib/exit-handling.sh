
exit_routine() {
  local -r script=${0-unknown}
  local -r exit_status=${1-unknown}
  local -r line_number=${2-unknown}
  local -r func_name=${3-unknown}

  if [ "${exit_status}" -ne '0' ]; then
    1>&2 echo "${script}: Error in ${func_name} on line ${line_number}"\
	      "with exit status ${exit_status}"
  fi

  exit ${exit_status}
}

trap 'exit_routine $? ${LINENO} ${FUNCNAME[0]:-${0}}' ERR

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
