#!/bin/bash

#
# Interface
#

wait_for_user() {
  local -r msg="${*}"

case "$(uname)" in
    Darwin)
        terminal-notifier -sound default <<< "${msg}"
    ;;
    Linux)
        notify-send "$0" "${msg}"
        2>&3 >&3 paplay --volume=41000 '/usr/share/sounds/freedesktop/stereo/complete.oga'
    ;;
esac


  read -n 1 -s -r -p "Press any key to continue"
  printf "\r"
}

#
# OS management
#

ensure_directory_exists() {
  if [ ! -d "${1}" ]; then
    mkdir -p "${1}"
  fi
}

safe_copy() {
  local -r runcom="${1}"
  local -r setup_dir="${2}"

  if [ "$(sha256sum < "${HOME}/.${runcom}")" \
       = "$(sha256sum < "${RUNCOMS_DIR}/${runcom}")" ]; then
    log "repo and system .${runcom} in sync"
  elif [ "$(sha256sum < "${HOME}/.${runcom}")" \
       = "$(head "${setup_dir}/old_${runcom}_sha.txt")" ]; then
    cp -f "${RUNCOMS_DIR}/${runcom}" "${HOME}/.${runcom}"
    log_warn "repo .${runcom} copied to system. Be sure to update old_${runcom}_sha.txt."
  else
    log_error "system .${runcom} has unmerged changes."
    exit 2
  fi
}

os-name() {
   tr '[:upper:]' '[:lower:]' <<< "$(uname)"
}
