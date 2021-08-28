#!/bin/bash

#
# Apt
#

ensure_package_installed() {
  local -r pkg_name="${*}"

  if dpkg -l | grep --quiet "${pkg_name}"; then
    sudo apt install "${pkg_name}"
  fi
}

#
# Git
#

clone_github_repo() {
  local -r clone_destination="${1:-.}"
  local -r repo_author="${2}"
  local -r repo_name="${3}"
  local -r url="https://github.com/${repo_author}/${repo_name}.git"

  local git_option='--'
  if [ "${VERBOSITY:-normal}" = 'low' ]; then
    git_option='--quiet'
  elif [ "${VERBOSITY:-normal}" = 'high' ]; then
    git_option='--verbose'
  fi

  2>&3 >&3 git clone "${git_option}" "$url" "$clone_destination"
}

# See http://stackoverflow.com/questions/3258243/check-if-pull-needed-in-git
repo_is_out_of_date() {
  local -r local="$( git rev-parse @  )"
  local -r remote="$( git rev-parse "@{u}" )"
  local -r base="$( git merge-base @ "@{u}" )"

  if [ "$local" = "$remote" ]; then
    return 1
  elif [ "$local" = "$base" ]; then
    return 0
  else
    log_warn "Warning: Git repo has diverged. Skipping..."
  fi
}

sync_git_repo() {
  local author="${1}"
  local   name="${2}"
  local   path="${3:-.}"

  if quiet_pushd "${path}/${name}"; then
    >&3 git fetch
    if repo_is_out_of_date; then
      2>&3 git pull origin master
    fi
    log "${name} up to date"
    quiet_popd
  else
    clone_github_repo "${name}" "${author}" "${name}"
    log_info "${name} installed"
  fi
}

#
# Pip
#

pip_install() {
  2>&3 >&3 python3 -m pip install "${*}"
}
