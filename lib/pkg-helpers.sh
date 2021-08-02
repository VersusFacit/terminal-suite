
is_installed() {
  local -r pkg_name="$@"
  dpkg -l "${pkg_name}"
}

ensure_package_installed() {
  local -r pkg_name="${@}"

  if ! very_quiet is_installed "${pkg_name}"; then
    log_quiet "installing ${pkg_name}..."
    sudo apt-get install "${pkg_name}"
  else
    log_quiet "${pkg_name} is already installed, skipping..."
  fi
}

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
  if [[ "${VERBOSITY:-0}" == 1 ]]; then
    git_option='--'
  elif [[ "${VERBOSITY:-0}" == 2 ]]; then
    git_option='--verbose'
  fi

  git clone "${git_option}" "$url" "$clone_destination"
}
