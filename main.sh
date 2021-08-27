#!/bin/bash

#
# 0. Setup
#
declare -r       LIB_DIR='./lib'
declare -r    PYTHON_DIR='./setup_python'
declare -r   RUNCOMS_DIR='./runcoms'
declare -r SOLARIZED_DIR='./setup_solarized'
declare -r       VIM_DIR='./setup_vim'

cd "$(dirname "$0")" || exit 1 # move to dir of this script during runtime

source "${LIB_DIR}/setup.sh"
source "${LIB_DIR}/exit-handling.sh"
source "${LIB_DIR}/logging-helpers.sh"
source "${LIB_DIR}/pkg-helpers.sh"
source "${LIB_DIR}/system-helpers.sh"

ensure_clean_git_tmp_dir_exists

ensure_install_all 'shellcheck' 'vim-gtk3' 'dconf-cli' 'curl' 'vlc' \
  'pulseaudio'

#
# 1. Solarized terminal setup
#
log_info 'Loading solarized installation module'
source "${SOLARIZED_DIR}/solarized_functions.sh"

log_info 'Installing solarized colors for gnome terminal'
install_solarized_terminal_colors

#
# 2. Vim setup
#

log_info 'Loading vim installation module'
source "${VIM_DIR}/vim_functions.sh"

log_info 'Installing package vim'
ensure_package_installed 'vim'
ensure_vim_directories_exist

log_info 'Installing pathogen'
ensure_pathogen_installed

#TODO: make robust checksum copy-paste setup to avoid losing edits to .vimrc and make it an idempotent installation at best
log_info 'Copying .vimrc'
cp "${RUNCOMS_DIR}/.vimrc" "${HOME}/.vimrc"

log_info 'Copying general vim plugins'
install_manifest_plugins 'vim-plugin-manifest.txt'

log_info 'Copying Powerline fonts for terminal'
install_powerline_fonts

#
# 2a. Vim Python setup
#

log_info 'Loading python installation module'
source "${PYTHON_DIR}/python_setup_functions.sh"

log_info 'Installing flake8 for syntastic'
install_flake8

log_info 'Copying Python vim plugins.'
install_manifest_plugins 'python-plugin-manifest.txt'

log_info 'Copying python virtual env autocomplete script.'
ensure_python_vim_directories_exist
copy_python_virtual_env_script

ping_for_jedi_vim_setup
