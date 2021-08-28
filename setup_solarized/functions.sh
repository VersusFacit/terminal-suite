#!/bin/bash -e

load_terminal_colors() {
  # Use a heredoc to automate the solarized installation process
  >&3 2>&3 dbus-launch ./install.sh --install-dircolors <<- "EOF"
    1
    2
    Yes
	EOF
}

install_solarized_terminal_colors() {
  local -r repo_name='gnome-terminal-colors-solarized'

  quiet_pushd "${CLONE_DIR}"
  log '* cloning gnome terminal colors solarized repo'
  clone_github_repo "${repo_name}" 'aruhier' "${repo_name}"
  quiet_pushd "${repo_name}"

  log '* installing solarized dircolors'
  load_terminal_colors

  quiet_popd
  quiet_popd
}
