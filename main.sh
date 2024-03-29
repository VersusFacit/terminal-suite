#!/bin/bash
REPO_ROOT=/Users/mila_fa/dev/terminal-suite

#
# 0. Environment setup
#
declare -r       LIB_DIR='./lib'
declare -r  MANIFEST_DIR='./manifests'
declare -r    PYTHON_DIR='./setup_python'
declare -r   RUNCOMS_DIR='./runcoms'
declare -r SOLARIZED_DIR='./setup_solarized'
declare -r     SHELL_DIR='./setup_shell'
declare -r       VIM_DIR='./setup_vim'

declare -r     CLONE_DIR='./git-tmp'

source "${LIB_DIR}/setup.sh"
source "${LIB_DIR}/exit-handling.sh"
source "${LIB_DIR}/logging-helpers.sh"
source "${LIB_DIR}/pkg-helpers.sh"
source "${LIB_DIR}/system-helpers.sh"

ensure_directory_exists "${CLONE_DIR}"

#
# 1. Install dependencies
#

# log_info 'Installing various software packages'
# while read -r package_name; do
#  log "checking for ${package_name}"
#  ensure_package_installed "${package_name}"
#  log "${package_name} installed"
# done < "${MANIFEST_DIR}/pkg-manifest.txt"

#
# 2. Solarized terminal setup
#

#
# 3. Vim setup
#

log_info 'Loading vim installation module'
source "${VIM_DIR}/functions.sh"

log_info 'Installing package vim'
ensure_directory_exists "${VIM_CONFIG_DIR}/autoload"
ensure_directory_exists "${VIM_CONFIG_DIR}/bundle"

log_info 'Installing pathogen'
ensure_pathogen_installed


log_info 'Installing vim plugins'
vim_plugin_install 'vim-plugin-manifest.txt'

log_info 'Copying Powerline fonts for terminal'
install_powerline_fonts

#
# 3a. Vim Python setup
#

log_info 'Installing flake8 for syntastic'
pip_install 'flake8'

log_info 'Copying Python vim plugins.'
vim_plugin_install 'python-plugin-manifest.txt'

wait_for_user 'User intervention needed:'\
  'Jedi requires "git submodule update --init --recursive"'

log_info 'Copying python virtual env autocomplete script.'
ensure_directory_exists "${VIM_CONFIG_DIR}/python"
cp -f "${PYTHON_DIR}/enable_virtual_env_autocomplete.py" "${VIM_CONFIG_DIR}/python"

#
# 3b. Vim C++ setup
#

#TODO
#https://stackoverflow.com/questions/4237817/configuring-vim-for-c

#
# 4. Readline setup
#

log_info 'Sychronizing .inputrc'
safe_copy 'inputrc' "${SHELL_DIR}"

#
# 5. Bashrc setup
#



#TODO: python venvs
#TODO: script repo management; debate moving those into this repo
#TODO: vimrc adjustments and additions
#TODO: figure out whether to checkin bashrc to git repo or not; componentize vim;
# and all components must have comments to make sense of things
# v--- these require research
#TODO: compression aliases
#TODO: network aliases
#TODO: rsync setup with backup disks
#TODO: get creative with arrays and dictionaries
#TODO: use group commands over subshells
