#!/bin/bash

#
# Apt
#

ensure_package_installed() {
  local -r pkg_name="${*}"

  if run_quiet dpkg -s "${pkg_name}"; then
    log_quiet "${pkg_name} is already installed, skipping..."
  else
    sudo apt-get install "${pkg_name}"
  fi
}

ensure_install_all() {
  for package_name in "${@}"; do
    log_info "Installing package ${package_name}"
    ensure_package_installed "${package_name}"
  done
}

#
# Git
#

ensure_clean_git_tmp_dir_exists() {
  if [ -d "${CLONE_DIR}" ]; then
    rm -rf "${CLONE_DIR}"
  fi
  mkdir "${CLONE_DIR}"
}

clone_github_repo() {
  local -r clone_destination="${1:-.}"
  local -r repo_author="${2}"
  local -r repo_name="${3}"
  local -r url="https://github.com/${repo_author}/${repo_name}.git"

  local git_option='--quiet'
  if [ "${VERBOSITY:-0}" = '1' ]; then
    git_option='--'
  elif [ "${VERBOSITY:-0}" = '2' ]; then
    git_option='--verbose'
  fi

  git clone "${git_option}" "$url" "$clone_destination"
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

fast_forward_repo_to_remote() {
  if ! grep --quiet "^Already up-to-date.$" <(2>&1 git pull origin master ); then
    echo 'Repo now up to date'
  fi
}

sync_git_repo() {
  local author="${1}"
  local   name="${2}"
  local   path="${3:-.}"

  if run_quiet 1>&2 pushd "${path}/${name}"; then
    run_quiet git fetch
    if repo_is_out_of_date; then
      fast_forward_repo_to_remote
    fi
    log_info "${name} up to date"
    run_quiet popd
  else
    clone_github_repo "${name}" "${author}" "${name}"
    log_info "${name} installed"
  fi
}

#
# Pip
#

install_flake8() {
  run_quiet python3 -m pip install flake8
}
