
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
