#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Variables
DOT="${HOME}/dotfiles"
CONFIG="${HOME}/.config"

# Define packages
declare -A packages=(
  [curl]="curl"
  [git]="git"
  [ripgrep]="rg"
  [unzip]="unzip"
  [ssh]="openssh-client"
  [cmake]="cmake"
  [make]="build-essential"
  [ninja]="ninja-build"
  [msgfmt]="gettext"
)

# Auto-Install required packages
for package in ${packages[@]}; do
  if ! [ -x $(which ${package}) ]; then
    sudo apt -y install ${package} &>/dev/null
  fi
done

# Ensure Starship is installed
if ! [ -x $(which starship) ]; then
  sh -c "$(curl -sS https://starship.rs/install.sh)" -- -y &>/dev/null
fi

# Get Neovim latest version
if ! [ -x $(which nvim) ]; then
  cd ~ 
  git clone https://github.com/neovim/neovim && cd neovim
  git checkout stable
  make CMAKE_BUILD_TYPE=RelWithDebInfo
  sudo make install
fi

# Ensure required directory exists
mkdir -p "${CONFIG}/git"
mkdir -p "${CONFIG}/nvim"
mkdir -p "${CONFIG}/bash"
mkdir -p "${HOME}/.ssh"

# Create dotfiles symlinks
ln -nsf "${DOT}/nvim/init.lua" "${CONFIG}/nvim/"
ln -nsf "${DOT}/git/config" "${CONFIG}/git/"
ln -nsf "${DOT}/bash/init.sh" "${CONFIG}/bash/"
ln -nsf "${DOT}/bash/config.sh" "${CONFIG}/bash/"
ln -nsf "${DOT}/starship/starship.toml" "${CONFIG}/"
ln -nsf "${DOT}/ssh/config" "${HOME}/.ssh/"

# Setup SSH
if ! [ -f "${HOME}/.ssh/gh_key" ]; then
    age -d -o "${HOME}/.ssh/gh_key" "${DOT}/ssh/gh_key.age"
    chmod 700 "${HOME}/.ssh" && chmod 600 "${HOME}/.ssh/gh_key"
    ssh-keygen -y -f "${HOME}/.ssh/gh_key" >"${HOME}/.ssh/gh_key.pub"
fi

# Reload Bash
echo "source ~/.config/bash/config.sh" >> ~/.bashrc
exec bash
