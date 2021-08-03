#!/bin/bash

#
# Interface
#

bell() {
  local -r BELL_FILEPATH='/usr/share/sounds/freedesktop/stereo/complete.oga'
  2>&1 paplay --volume=41000 "${BELL_FILEPATH}"
}

wait_for_enter() {
  read -n 1 -s -r -p "Press any key to continue"
  printf "\r"
}

wait_for_user_intervention() {
  local -r msg="${*}"
  notify-send "$0" "${msg}"
  run_quiet bell
  wait_for_enter
}

#
# OS management
#

ensure_directory_exists() {
  if [ ! -d "${1}" ]; then
    mkdir -p "${1}"
  fi
}

