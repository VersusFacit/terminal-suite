
ensure_python_vim_directories_exist() {
  ensure_directory_exists "${VIM_CONFIG_DIR}/python"
}

copy_python_virtual_env_script() {
  cp "${PYTHON_DIR}/enable_virtual_env_autocomplete.py" \
      "${VIM_CONFIG_DIR}/python"
}

ping_for_jedi_vim_setup() {
  local -r msg=$(echo 'User action needed: Run "git submodule' \
    'update --init --recursive".')
  wait_for_user_intervention "${msg}"
}

