#!/bin/bash

#
# 0. Setup
#
LIB_DIR='./lib'
CLONE_DIR='./git-tmp'

# Enter root of script repository to ensure relative path correctness
cd "$(dirname "$0")"

source "${LIB_DIR}/setup.sh"
source "${LIB_DIR}/exit-handling.sh"
source "${LIB_DIR}/logging-helpers.sh"
source "${LIB_DIR}/pkg-helpers.sh"

ensure_clean_git_tmp_dir_exists

#
# 1. Solarized terminal setup
#
declare -r SOLARIZED_DIR='solarized_setup/'

log_info 'Installing package dconf-cli'
ensure_package_installed 'dconf-cli'

log_info 'Loading solarized module'
source "${LIB_DIR}/solarized_functions.sh"

log_info 'Installing solarized colors for gnome terminal'
install_solarized_terminal_colors

