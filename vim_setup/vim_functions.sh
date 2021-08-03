
VIM_CONFIG_DIR="$HOME/.vim"

ensure_vim_directories_exist() {
  ensure_directory_exists "${VIM_CONFIG_DIR}/autoload"
  ensure_directory_exists "${VIM_CONFIG_DIR}/bundle"
}

ensure_pathogen_installed() {
  local -r pathogen_path="${VIM_CONFIG_DIR}/autoload/pathogen.vim"

  # pathogen is a single file, so its existence implies installation
  if [ -s "${pathogen_path}" ]; then
    log_quiet 'Pathogen already installed. Skipping...'
  else
    ## Ref: https://github.com/tpope/vim-pathogen#installation
    curl --location --silent --show-error --output "${pathogen_path}" \
        'https://tpo.pe/pathogen.vim'
  fi
}

ensure_vim_plugin_installed() {
  local -r author="${1}"
  local -r plugin_name="${2}"

  local -r bundle_path="${VIM_CONFIG_DIR}/bundle"

  if run_quiet 1>&2 pushd "${bundle_path}"; then
    sync_git_repo "${author}" "${plugin_name}"
    run_quiet popd
  fi
}

install_manifest_plugins() {
  local -r filename="./manifests/${*}"

  if [ -f "${filename}" ]; then
    while read -r line; do
      # N.B. keep $line unquoted to avoid one argument
      ensure_vim_plugin_installed ${line}
    done < "${filename}"
  else
    log_error "No file ${filename} found. Exiting..."
    return 1
  fi
}

install_powerline_fonts() {
  if ! run_quiet &>/dev/null find "$HOME/.local/share/fonts/*Powerline*"; then
    run_quiet pushd ~/.vim/bundle/fonts
      ./install.sh
    run_quiet popd
  fi

  log_info "Powerline fonts installed."
  local -r msg='User action needed: Add the powerline font to profile.'
  wait_for_user_intervention "${msg}"
}

