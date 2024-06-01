#!/bin/bash -e

# ✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦
# Prerequisite Packages ✦ 
# ✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦

install_missing_package_manager() {
    if which -s brew; then
        log_info "Homebrew already installed."
    else
        # May 2024
        local -r url="https://raw.githubusercontent.com/Homebrew/install/e65f88c8b7a49ce741a7092ab22774d2fdd798c0/install.sh"
        local -r checksum="67b0989bd0a404cdd32c1df20e3fb724b7c278c83a068fd5a16dac6f8d317a79"
        local -r script_name="install_homebrew.sh"

        curl -o "${script_name}" "${url}"
        shasum -c - <<< "${checksum}  ${script_name}"

        NONINTERACTIVE=1 bash "${script_name}"
    fi

    brew cleanup
    brew update --force --quiet
    brew doctor
}

ensure_package_installed() {
    local -r package_name="${1}"
    log_info "checking for ${package_name}"
    if brew list | grep --quiet "${package_name}"; then
        log_info "${package_name} already installed"
    else
        brew install "${package_name}"
        log_info "${package_name} installed"
    fi
}


# ✦✦✦✦✦
# Git ✦ 
# ✦✦✦✦✦

clone_github_repo() {
    local -r clone_destination="${1:-.}"
    local -r repo_author="${2}"
    local -r repo_name="${3}"
    local -r url="https://github.com/${repo_author}/${repo_name}.git"

    local git_option='--'
    if [ "${VERBOSITY:-normal}" = 'low' ]; then
      git_option='--quiet'
    elif [ "${VERBOSITY:-normal}" = 'high' ]; then
      git_option='--verbose'
    fi

    2>&3 >&3 git clone "${git_option}" "${url}" "${clone_destination}"
}

# See http://stackoverflow.com/questions/3258243/check-if-pull-needed-in-git
repo_is_out_of_date() {
    local -r local="$( git rev-parse @  )"
    local -r remote="$( git rev-parse "@{u}" )"
    local -r base="$( git merge-base @ "@{u}" )"

    if [ "$local" = "$remote" ]; then
        return 1
    elif [ "$local" = "$base" ]; then
        return 0
    else
        log_warn "Warning: Git repo has diverged. Skipping..."
    fi
}

sync_git_repo() {
    local author="${1}"
    local   name="${2}"
    local   path="${3:-.}"

    if [ -d "${path}/${name}" ]; then
        quiet_pushd "${path}/${name}"
        >&3 git fetch
        if repo_is_out_of_date; then
            2>&3 git pull origin master
        fi
        log "${name} up to date"
        quiet_popd
    else
        clone_github_repo "${path}/${name}" "${author}" "${name}"
        log_info "${name} installed"
    fi
}

# ✦✦✦✦✦
# Pip ✦ 
# ✦✦✦✦✦

pip_install() {
    2>&3 >&3 python3 -m pip install "${*}"
}
