#!/bin/bash -e
REPO_ROOT=$HOME/dev/terminal-suite

# ------------
# Prequisites
# ------------

# 1. Iterm set on solarized
# 2. Xcode utils
# 3. Run this script from the root of the git repo located in `~/dev`

# ✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦
# 0. Environment setup ✦
# ✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦

case "$(uname)" in
    Darwin)
        declare -r LIB_DIR="${REPO_ROOT}/lib_mac"
	      source "${REPO_ROOT}/lib/setup.sh"
	      source "${REPO_ROOT}/lib/exit-handling.sh"
	      source "${REPO_ROOT}/lib/logging-helpers.sh"
	      source "${REPO_ROOT}/lib_darwin/pkg-helpers.sh"
	      source "${REPO_ROOT}/lib/system-helpers.sh"
	      source "${REPO_ROOT}/lib_darwin/term-helpers.sh"
    ;;
    Linux)
        declare -r LIB_DIR="${REPO_ROOT}/lib"
    ;;
esac

declare -r  MANIFEST_DIR="${REPO_ROOT}/manifests"
declare -r    PYTHON_DIR="${REPO_ROOT}/setup_python"
declare -r   RUNCOMS_DIR="${REPO_ROOT}/runcoms"
declare -r SOLARIZED_DIR="${REPO_ROOT}/setup_solarized"
declare -r     SHELL_DIR="${REPO_ROOT}/setup_shell"
declare -r       VIM_DIR="${REPO_ROOT}/setup_vim"

declare -r     CLONE_DIR="${REPO_ROOT}/git-tmp"
ensure_directory_exists "${CLONE_DIR}"

# ✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦
# 1. Install Packages ✦
# ✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦

log_info 'Installing and configuring a package manager'
install_missing_package_manager

log_info 'Installing various software packages'
while read -r package_name; do
    ensure_package_installed "${package_name}"
done < "${MANIFEST_DIR}/$(os-name)-pkg-manifest.txt"

# ✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦
# 2. Solarized terminal setup ✦
# ✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦

log_info 'Setting up terminal colors'
ensure_directory_exists "${REPO_ROOT}/keep"
install_dircolors

# ✦✦✦✦✦✦✦✦✦✦✦✦✦✦
# 3. Vim Setup ✦
# ✦✦✦✦✦✦✦✦✦✦✦✦✦✦

log_info 'Loading vim installation module'
source "${VIM_DIR}/functions.sh"

log_info 'Outfit local machine with vimrc'
install_vimrc

log_info 'Installing package vim'
ensure_directory_exists "${VIM_CONFIG_DIR}/autoload"
ensure_directory_exists "${VIM_CONFIG_DIR}/bundle"

log_info 'Installing pathogen'
ensure_pathogen_installed

log_info 'Installing vim plugins'
vim_plugin_install 'vim-plugin-manifest.txt'

log_info 'Copying Powerline fonts for terminal'
install_powerline_fonts

# ✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦
# 3a. Vim Python ✦
# ✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦

log_info 'Copying Python vim plugins.'
vim_plugin_install 'python-plugin-manifest.txt'

wait_for_user 'User intervention needed:'\
    'Jedi requires "git submodule update --init --recursive"'

log_info 'Copying python virtual env autocomplete script.'
ensure_directory_exists "${VIM_CONFIG_DIR}/python"
cp -f "${PYTHON_DIR}/enable_virtual_env_autocomplete.py" "${VIM_CONFIG_DIR}/python"

# ✦✦✦✦✦✦✦✦✦✦✦✦✦
# 3b. Vim C++ ✦
# ✦✦✦✦✦✦✦✦✦✦✦✦✦


#
# 4. Readline setup
#

# log_info 'Sychronizing .inputrc'
# safe_copy 'inputrc' "${SHELL_DIR}"

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
