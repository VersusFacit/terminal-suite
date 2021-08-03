
clone_solarized_colors() {
  local -r repo_name="${*}"
  log_info '* Cloning gnome terminal colors solarized repo'
  clone_github_repo "${repo_name}" 'aruhier' "${repo_name}"
}

load_terminal_colors() {
  # Use a heredoc to automate the solarized installation process
  log_info '* Installing solarized dircolors'
  out=$(2>&1 dbus-launch ./install.sh --install-dircolors <<- "EOF"
    1
    2
    Yes
	EOF
  )
}

install_solarized_terminal_colors() {
  local -r repo_name='gnome-terminal-colors-solarized'

  run_very_quiet pushd "${CLONE_DIR}"
  clone_solarized_colors "${repo_name}"
  run_very_quiet pushd "${repo_name}"

  load_terminal_colors

  run_very_quiet popd
  run_very_quiet popd
}

