#!/bin/bash

VIM_CONFIG_DIR="$HOME/.vim"

ensure_pathogen_installed() {
  local -r pathogen_path="${VIM_CONFIG_DIR}/autoload/pathogen.vim"

  # pathogen is a single file, so its existence implies installation
  if [ -s "${pathogen_path}" ]; then
    log 'Pathogen already installed. Skipping...'
  else
    ## Ref: https://github.com/tpope/vim-pathogen#installation
    curl --location --silent --show-error --output "${pathogen_path}" \
        'https://tpo.pe/pathogen.vim'
  fi
}

vim_plugin_install() {
  local -r filename="./manifests/${*}"
  local -r bundle_path="${VIM_CONFIG_DIR}/bundle"
  if [ -f "${filename}" ]; then
    echo "${VIM_CONFIG_DIR}/bundle"
    while read -r author plugin; do
      if quiet_pushd "${bundle_path}"; then
        sync_git_repo "${author}" "${plugin}"
        quiet_popd
      fi
    done < "${filename}"
  else
    log_error "No file ${filename} found. Exiting..."
    return 1
  fi
}

install_powerline_fonts() {
  if ! find ~/.local/share/fonts/*Powerline* &>/dev/null; then
    quiet_pushd "${HOME}/.vim/bundle/fonts"
      2>&3 >&3 ./install.sh
    quiet_popd
  fi
  log "Powerline fonts installed."

  wait_for_user 'User intervention needed: Add the powerline font to profile.'
}


install_vimrc() {
    local -r tracked_vimrc="${REPO_ROOT}/runcoms/vimrc"
    local -r   local_vimrc="${HOME}/.vimrc"

    if [ -f "${local_vimrc}" ]; then
        if diff -q "${tracked_vimrc}" "${local_vimrc}" > /dev/null; then
            log_warn "vimrc already installed. Skipping..."
        else
            log_error "vimrc already installed but local has untracked changes. Aborting..."
            exit 2
        fi
    else
        cp "$REPO_ROOT/runcoms/vimrc" "$HOME/.vimrc"
    fi
}
